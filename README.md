#  HW-04 上傳指引


## 作業要求
1. 使用operator-sdk建立CRD與相對應的Controller
2. 建立 CRD 的 資訊如下：
   * Kind: Web
   * Group: hw4
   * Domain: ntcu.edu.tw
3. CRD 的Spec需含
   * Image, 類型為String
   * NodePortNumber, 類型為int32
4. 完成的CRD的YAML範例如下：
      ```yaml
      apiVersion: hw4.ntcu.edu.tw/v1alpha1
      kind: Web
      metadata:
        name: web-sample
      spec:
        image: "nginx:1.7.9"
        nodePortNumber: 31234
      ```
5. Web CRD的Controller 發覺 Web CRD建立時，產生一個Deployment與Service。
   * Deployment與Service均會有key為`ntcu-k8s`, value為`hw4`的label
   * 建立Deployment，image使用由Web CRD裡的Image欄位取得
   * 建立Service，類型使用NodePort, NodePort的值，由Web CRD裡的nodePortNumber欄位取得
   * 從本地利用curl透過NodePort存取Deployment的web service
6. 刪除Web CRD時，會同時刪除Controller建立的Deployment與Service
7. 利用operator-sdk所產生的Makefile裡的`make generate`、`make manifest`、`make install`、`make deploy`、`make docker-build`進行編譯、部署等操作。
8. 執行 `make deploy` 或 `make all -f .validate/Makefile` 前，確認執行下列二個修改
   * `config/manager/manager.yaml` 中 , `image: controller:latest` 下面請多加一行 `imagePullPolicy: IfNotPresent`
     ```yaml
     ...
      image: controller:latest
      imagePullPolicy: IfNotPresent
     ...
     ```
   * `config/rbac/kustomization.yaml`裡的倒數四行 `- auth_proxy_*.yaml`註解掉


## 繳交作業流程
1. fork [upstream HW-04 專案](https://github.com/ogre0403/110-2-ntcu-k8s-programing-HW-04) 至自己的Github帳號的downstream HW-04專案。
2. 依作業要求撰寫相關程式碼後，commit/push至自己Github帳號的downstream HW-04專案。
3. 向upstream HW-04 專案的 `main` 分支發起pull request。
4. 建立PR時，請注意下列要求。**若不符合，會導致Github自動測試失敗，而無法完成繳交。**
   * 建立manifest目錄，將YAML檔至於manifest目錄內
   * 建立的PR名稱 必為 `HW-04-[a-z]{3}[0-9]{6}`
   * 嚴禁修改 `.validate/*`以及 `.github/workflows` 的內容。若有修改，會導致無法建立PR
   * 本次作業deadline為 `2022/07/01 00:00`
5. 約15~20分鐘後，至 [upstream HW-04 專案 PR頁面](https://github.com/ogre0403/110-2-ntcu-k8s-programing-HW-04/pulls)，檢視是否測試成功。
   * 若不成功，依測試結果的錯誤訊息進行修正後再重新push即可，**不用再建立新的PR**.
   * 在deadline前可以無限重新push修正的版本，直到測試成功。
## 若測試不成功該怎麼辦?
1. 請先確認撰寫的程式是否有問題，並依相每次的作業上傳要求進行配置。
2. Github啟重測式約有10~15分鐘的等待，再上傳前，可以先在本地執行測試. (測試script支援Linux/MacOS)
   ```shell
   $ make all -f .validate/Makefile
   ```
3. 自動化測試，仍有可能因未考量周全造成測試失敗。若認為作業已依繳交要求進行繳交，但測試程式仍測試失敗，請再和老師聯絡。