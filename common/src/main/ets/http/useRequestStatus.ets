import axios from '@ohos/axios';
import { EmptyState } from '../components/StateComponent';
import { CommonType } from '../common/TypeAlias';

export interface LoadStateResult {
  promise: <T>(requestPromise: Promise<T>, showLoadingState?: boolean) => Promise<T>
}

function updateViewState(state: number, stateCallback?: (state: number) => void) {
  stateCallback?.(state)
}

function run<T>(requestPromise: Promise<T>, showLoadingState?: boolean, stateCallback?: (state: number) => void): Promise<T> {
  if (showLoadingState !== false) {
    updateViewState(EmptyState.stateLoading, stateCallback)
  }
  return new Promise<T>((resolve, reject) => {
    requestPromise.then((res) => {
      updateViewState(EmptyState.stateSuccess, stateCallback)
      resolve(res);
    }).catch((error: CommonType) => {
      if (axios.isAxiosError(error)) {
        updateViewState(EmptyState.stateNoNet, stateCallback)
      } else {
        updateViewState(EmptyState.stateFail, stateCallback)
      }
      reject(error);
    })
  })
}

function useRequestStatus(stateCallback?: (state: number) => void): LoadStateResult {
  return {
    promise: (requestPromise, showLoadingState) => run(requestPromise, showLoadingState, stateCallback)
  };
}

export default useRequestStatus;


