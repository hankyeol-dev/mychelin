# Mychelin (마이슐랭)

나만의 맛집을 마이슐랭에 등록하고 위치 기반으로 다른 유저의 마이슐랭을 수집하는 앱

**목차** <br />
> [프로젝트 소개](#프로젝트-소개) <br />
> [프로젝트 아키텍처와 스택](#프로젝트-아키텍처-및-스택) <br />
> [프로젝트 주요 구현 사항](#프로젝트-주요-구현-사항) <br />
> [프로젝트 구현 화면](#프로젝트-구현-화면)

<br />

## 프로젝트 소개

- 개발 인원 : 강한결 (1인 프로젝트, 백엔드 개발자 서버 협업)
- 기간 : 2025.01.24 ~ 02.14 (3주)
- 최소 버전 : iOS 16.0
- 주요 기능
  - 위치 기반 맛집 기록
  - 유저 위치 기반으로 등록된 맛집 포스트 조회
  - 맛집 포스트 찜 및 기록 통합 조회

<br />

## 프로젝트 아키텍처 및 스택

| 스택 | 활용 |
|:-|:-|
| **ReactorKit** | ViewController - Reactor 기반 단방향 데이터 플로우 아키텍처 |
| **Tuist** | 프로젝트 설정 및 모듈 분리 |
| **UIKit, SnapKit** | 컴포넌트 및 레이아웃 구현 |
| **RxSwift** | View 이벤트 처리 및 상태 데이터 흐름 관리 |
| **RxDataSource** | Section별 CollectionView, TableView 데이터 모델 구성 |
| **Moya** | 네트워크 객체 구성 및 통신 |
| **네이버 지도 / 카카오 장소 검색 API** | 지도 UI 및 위치 데이터 활용 |

<br />

## 프로젝트 주요 구현 사항

### ReactorKit 기반 아키텍처 적용
<img src="https://github.com/user-attachments/assets/b26b0dff-aa4f-4d99-9377-ab855b3fce2e" width="400" />

- ReactorKit을 적용하여 **Reactor의 Reducer로만 View 상태값이 변경되는 단방향 데이터 플로우 아키텍처 반영**
- ViewController에서는 Reactor에 등록된 Action Case로만 요청을 보내고, 업데이트된 상태를 Observable로 구독하여 View 업데이트
- Features 모듈의 ViewController가 동일한 형식의 Reactor와 연결되어 예측하기 쉬운 코드 구성

### Tuist를 활용한 프로젝트 모듈 구분

<img src="https://github.com/user-attachments/assets/992b9a2e-c3bf-494d-aa0c-3174ef978293" width="600" />

- Tuist를 이용해 App을 구성하는 Scene(Feature), UI, Domain Logic, Data Logic 계층 단위로 구분
- 네트워크, DTO 객체를 관리하는 **Data Layer** / Usecase, 서비스 로직을 관리하는 **Domain Layer** 구분
- 서드파티 프레임워크를 다이내믹 프레임워크 형태로 각 모듈에 주입

### 위치 기반 포스트 작성, 조회

- 마이슐랭(나의 맛집) 포스트 작성 시, 카카오 장소 검색 API를 활용하여 지정 장소의 정확한 위·경도 값을 조회하여 POST API 바디에 함께 전송
- **서버 Geolocation Search API를 활용해 유저의 위·경도 값을 중심으로 특정 거리(Max Distance)안에 등록된 포스트를 조회**
- 네이버 지도 API의 CameraDelegate로 **유저가 이동하거나 지도 상의 위치를 수동으로 변경하는 경우를 감지하여 포스트를 다시 받아오는 버튼 노출 (Reload Button)**
- 네이버 지도 상에서 불러온 **포스트 리스트를 커스텀 마커로 노출하고, Marker Tap API로 특정 포스트 조회**
- CoreLocationManager로 유저의 실시간 위치 정보를 네이버 지도에 반영

### SectionModel 기반 테이블/컬랙션 뷰 설계

- RxDataSource의 SectionModel 타입을 활용하여 테이블, 컬랙션 뷰의 Section, Item 데이터 타입 명세
- Reactor에서 섹션별 데이터 타입을 상태값으로 관리하여 API 통신으로 데이터 맵핑
- RxReloadDataSource API로 각 섹션에 Custom Cell, SectionModel 바인딩

### NWMonitor를 활용한 네트워크 모니터링

- 모든 Scene에서 네트워크 통신이 있어서, 앱 전역적으로 네트워크 연결을 감지할 수 있는 NetworkMonitorService 객체 구현
- 서비스 객체 내부에서 Network 모듈의 NWPathMonitor를 활용해 네트워크 연결을 확인하고, 연결이 끊긴 경우 클로저 구문이 실행되는 API 반영
  <details>
    <summary>코드</summary>
    NetworkMonitorService 객체
    
    ```swift
    public func startMonitor(_ handler: @escaping (Bool) -> Void) {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
           guard let self else { return }
           isNetworkConnected = path.status == .satisfied
           setNetworkConnectionType(path)
           
           DispatchQueue.main.async { [weak self] in
              guard let self else { return }
              handler(isNetworkConnected)
           }
        }
     }
    ```
  </details>
- SceneDelegate의 willConnectTo, sceneDidDisconnect 메서드에서 네트워크 모니터링을 진행. 네트워크 연결이 끊긴 경우, ErrorView를 `.statusBar` 레이어로 노출

<br />

## 프로젝트 구현 화면

| 홈 - 마이슐랭 지도 | 홈 - 마이슐랭 선택 | 마이슐랭 상세 화면 |
|:--:|:--:|:--:|
|<img src="https://github.com/user-attachments/assets/389d3492-0808-4e87-ac5d-d151e92840c3" width="250" />|<img src="https://github.com/user-attachments/assets/0330bf4a-865f-4f5f-9824-6618614c1783" width="250" />|<img src="https://github.com/user-attachments/assets/7b865651-98fd-4f12-a425-b8518eca19a0" width="250" />

- 네이버 지도 기반으로 내 위치 주변의 마이슐랭(맛집 포스트) 리스트를 조회할 수 있습니다.
- 지도를 수동으로 이동하여 특정 위치 주변의 마이슐랭 리스트도 조회할 수 있습니다.
- 특정 맛집에 대해 유저가 남긴 리뷰를 상세하게 확인할 수 있습니다.

<br />

|마이슐랭 카테고리 설정| 마이슐랭 작성 | 마이슐랭 작성 |
|:--:|:--:|:--:|
|<img src="https://github.com/user-attachments/assets/7ea60c59-f1e2-426c-8c70-1398fd54716e" width="250" />|<img src="https://github.com/user-attachments/assets/180a52be-777c-4ed1-95f0-ffc97769287b" width="250" />|<img src="https://github.com/user-attachments/assets/33dcc02d-587a-471e-8af9-54ae14b490fa" width="250" />|

- 20개 이상의 음식 카테고리 중 하나를 선택하여 마이슐랭 포스트를 작성할 수 있습니다.
- 맛집 리뷰를 남기고 최대 3장의 이미지와 별점을 남길 수 있습니다.
- KAKAO 장소 검색 API를 활용하여 맛집의 정확한 위치를 검색할 수 있습니다.

<br />

|마이페이지 - 마이슐랭 리스트 | 마이페이지 - 내가 찜한 마이슐랭|
|:--:|:--:|
|<img src="https://github.com/user-attachments/assets/1ff07ad4-4819-4d49-bddc-2e258eec9b1b" width="250" />|<img src="https://github.com/user-attachments/assets/5acd567a-5e5f-40a1-a845-edc6803e8bfd" width="250" />|

- 마이페이지에서 내가 남긴 마이슐랭 리스트, 내가 찜한 마이슐랭 리스트를 모아볼 수 있습니다.
