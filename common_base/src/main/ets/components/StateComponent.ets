
import { EmptyComponent } from './EmptyComponent'
import { LoadingComponent } from './LoadingComponent'
@Component
export struct StateComponent {
  @Prop state: number
  @BuilderParam viewContent: () => void
  //重试的回调方法
  retryCallback?: () => void
  build(){
    if (this.state == EmptyState.stateSuccess) {
      Column(){
        this.viewContent()
      }
    } else {
      Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.Center}){
        if (this.state == EmptyState.stateLoading) {
            LoadingComponent()
          } else {
            EmptyComponent({state:this.state,retryCallback:this.retryCallback})
          }
      }
    }
  }
}

export enum EmptyState {
  stateLoading = 0,
  stateEmpty,
  stateFail,
  stateNoNet,
  stateSuccess
}