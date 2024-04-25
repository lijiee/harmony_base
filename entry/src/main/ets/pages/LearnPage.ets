
import { RenderNode, FrameNode, NodeController, Size, DrawContext } from "@ohos.arkui.node"
import { common2D, drawing } from '@kit.ArkGraphics2D';
import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import { componentSnapshot } from '@kit.ArkUI';
import { showToast } from '@ohos/common_base';

@Entry
@Component
export struct LearnPage {
  private myNodeController: MyNodeController = new MyNodeController();
  private currentNode: MyRenderNode | null = null; // 当前正在绘制的节点
  private nodeCount: number = 0; // 已挂载到根节点的子节点数量

  build() {
    Column() {
      NodeContainer(this.myNodeController)
        .width('100%')
        .height('40%')
        .onTouch((event: TouchEvent) => {
          this.onTouchEvent(event);
        })
        .id("NODE_CONTAINER_ID")
      Row() {
        Button("重置")
          .onClick(() => this.resetCanvas())
        Button("撤销")
          .onClick(() => this.goBack())
        Button("保存")
          .onClick(() => this.packToFile())
      }
    }
    .width('100%')
    .height('100%')
  }

  onTouchEvent(event: TouchEvent): void {
    // TODO：知识点：在手指按下时创建新的MyRenderNode对象，挂载到rootRenderNode上，手指移动时根据触摸点坐标绘制线条，并重新渲染节点
    // 获取手指触摸位置的坐标点
    const positionX: number = vp2px(event.touches[0].x);
    const positionY: number = vp2px(event.touches[0].y);
    switch (event.type) {
      case TouchType.Down: {
        // 每次手指按下，创建一个MyRenderNode对象，用于记录和绘制手指移动的轨迹
        const newNode = new MyRenderNode();
        // 定义newNode的大小和位置，位置从组件NodeContainer的左上角(0,0)坐标开始，大小为NodeContainer的宽高
        newNode.frame = { x: 0, y: 0, width: this.myNodeController.width, height: this.myNodeController.height };
        this.currentNode = newNode;
        // 移动新节点中的路径path到手指按下的坐标点
        this.currentNode.path.moveTo(positionX, positionY);
        if (this.myNodeController.rootRenderNode !== null) {
          // appendChild在renderNode最后一个子节点后添加新的子节点
          this.myNodeController.rootRenderNode.appendChild(this.currentNode);
          // 已挂载的节点数量加一
          this.nodeCount++;
        }
        break;
      }
      case TouchType.Move: {
        if (this.currentNode !== null) {
          // 手指移动，绘制移动轨迹
          this.currentNode.path.lineTo(positionX, positionY);
          // 节点的path更新后需要调用invalidate()方法触发重新渲染
          this.currentNode.invalidate();
        }
        break;
      }
      case TouchType.Up: {
        // 手指抬起，释放this.currentNode
        this.currentNode = null;
      }
      default: {
        break;
      }
    }
  }

  resetCanvas() {
    if (this.myNodeController.rootRenderNode !== null && this.nodeCount > 0) {
      // 清除当前rootRenderNode的所有子节点
      this.myNodeController.rootRenderNode.clearChildren();
      this.nodeCount = 0;
    }
  }

  goBack() {
    if (this.myNodeController.rootRenderNode !== null && this.nodeCount > 0) {
      // getChild获取最后挂载的子节点
      const node = this.myNodeController.rootRenderNode.getChild(this.nodeCount - 1);
      // removeChild移除指定子节点
      this.myNodeController.rootRenderNode.removeChild(node);
      this.nodeCount--;
    }
  }

  async packToFile() {
    componentSnapshot.get("NODE_CONTAINER_ID", async (error: Error, pixelMap: image.PixelMap) => {
      if (pixelMap !== null) {
        // 创建图像编码ImagePacker对象
        const imagePackerApi = image.createImagePacker();
        // 设置编码输出流和编码参数。format为图像的编码格式；quality为图像质量，范围从0-100，100为最佳质量
        const options: image.PackingOption = { format: "image/jpeg", quality: 100 };
        let date = new Date()
        // 图片写入的沙箱路径
        const filePath: string = `${getContext().filesDir}/${date.getTime()}.jpg`;
        const file: fs.File = await fs.open(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
        // 使用packing打包获取图片的ArrayBuffer
        const data: ArrayBuffer = await imagePackerApi.packing(pixelMap, options);
        // 将图片的ArrayBuffer数据写入文件
        fs.writeSync(file.fd, data);
        fs.closeSync(file);
        showToast("保存成功")
      }
    })
  }
}
export class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null; // 根节点
  rootRenderNode: RenderNode | null = null; // 从NodeController根节点获取的RenderNode，用于添加和删除新创建的MyRenderNode实例
  width: number = 0; // 实例绑定的NodeContainer组件的宽，单位px
  height: number = 0; // 实例绑定的NodeContainer组件的宽，单位px

  // MyNodeController实例绑定的NodeContainer创建时触发，创建根节点rootNode并将其挂载至NodeContainer
  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext);
    if (this.rootNode !== null) {
      this.rootRenderNode = this.rootNode.getRenderNode();
    }
    return this.rootNode;
  }

  // 绑定的NodeContainer布局时触发，获取NodeContainer的宽高
  aboutToResize(size: Size): void {
    this.width = size.width;
    this.height = size.height;
    // 设置画布底色为白色
    if (this.rootRenderNode !== null) {
      // NodeContainer布局完成后设置rootRenderNode的背景色为白色
      this.rootRenderNode.backgroundColor = 0XFFFFFFFF;
      // rootRenderNode的位置从组件NodeContainer的左上角(0,0)坐标开始，大小为NodeContainer的宽高
      this.rootRenderNode.frame = { x: 0, y: 0, width: this.width, height: this.height };
    }
  }
}

export class MyRenderNode extends RenderNode {
  path: drawing.Path = new drawing.Path(); // 新建路径对象，用于绘制手指移动轨迹

  // RenderNode进行绘制时会调用draw方法，初始化画笔和绘制路径
  draw(context: DrawContext): void {
    const canvas = context.canvas;
    // 创建一个画笔Pen对象，Pen对象用于形状的边框线绘制
    const pen = new drawing.Pen();
    // 设置画笔开启反走样，可以使得图形的边缘在显示时更平滑
    pen.setAntiAlias(true);
    // 设置画笔颜色为黑色
    const pen_color: common2D.Color = { alpha: 0xFF, red: 0x00, green: 0x00, blue: 0x00 };
    pen.setColor(pen_color);
    // 开启画笔的抖动绘制效果。抖动绘制可以使得绘制出的颜色更加真实。
    pen.setDither(true);
    // 设置画笔的线宽为5px
    pen.setStrokeWidth(5);
    // 将Pen画笔设置到canvas中
    canvas.attachPen(pen);
    // 绘制path
    canvas.drawPath(this.path);
  }
}
