# Mychelin (마이슐랭)

나만의 맛집을 마이슐랭에 등록하고 위치 기반으로 다른 유저의 마이슐랭을 수집하는 앱

> **목차** <br />
> [프로젝트 소개](#프로젝트-소개) <br />
> [프로젝트 아키텍처와 스택](#프로젝트-아키텍처-및-스택) <br />
> [프로젝트 주요 구현 사항](#프로젝트-주요-구현-사항) <br />
> [프로젝트 구현 화면](#프로젝트-구현-화면)

<br />

### 프로젝트 소개

- 개발 인원 : 강한결 (1인 프로젝트, 백엔드 개발자 서버 협업)
- 기간 : 2025.01.24 ~ 02.14 (3주)
- 최소 버전 : iOS 16.0
- 주요 기능
  - 위치 기반 맛집 기록
  - 유저 위치 기반으로 등록된 맛집 포스트 조회
  - 맛집 포스트 찜 및 기록 통합 조회

<br />

### 프로젝트 아키텍처 및 스택

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

### 프로젝트 주요 구현 사항

#### ReactorKit 기반 아키텍처 적용
<img src="https://github.com/user-attachments/assets/b26b0dff-aa4f-4d99-9377-ab855b3fce2e" width="400" />

- ReactorKit을 적용하여 **Reactor의 Reducer로만 View 상태값이 변경되는 단방향 데이터 플로우 아키텍처 반영**
- ViewController에서는 Reactor에 등록된 Action Case로만 요청을 보내고, 업데이트된 상태를 Observable로 구독하여 View 업데이트
- Features 모듈의 ViewController가 동일한 형식의 Reactor와 연결되어 예측하기 쉬운 코드 구성
<br />

#### Tuist를 활용한 프로젝트 모듈 구분

<img src="https://github.com/user-attachments/assets/992b9a2e-c3bf-494d-aa0c-3174ef978293" width="600" />

- App을 구성하는 Scene, UI, Domain Logic, Data Logic 계층 단위로 모듈을 구분하기 위해 Tuist 활용

#### 위치 기반 포스트 작성, 조회

- 마이슐랭(나의 맛집) 포스트 작성 시, 카카오 장소 검색 API를 활용하여 지정 장소의 정확한 위·경도 값을 조회하여 POST API 바디에 함께 전송
- 네이버 지도 상에서 CoreLocationManager의 실시간 유저 위치를 반영
- 서버 Geolocation Search API를 활용해 **유저의 위·경도 값을 중심으로 특정 거리(Max Distance)안에 등록된 포스트를 조회**
- 네이버 지도 API의 CameraDelegate로 **유저가 이동하거나 지도상의 위치를 수동으로 변경하는 경우를 감지하여 포스트를 다시 받아오는 버튼 노출 (Reload Button)**


<br />

### 프로젝트 구현 화면

| 홈 - 마이슐랭 지도 | 홈 - 마이슐랭 선택 | 마이슐랭 디테일 |
|:--:|:--:|:--:|
|<img src="https://github.com/user-attachments/assets/389d3492-0808-4e87-ac5d-d151e92840c3" width="250" />|<img src="https://github.com/user-attachments/assets/0330bf4a-865f-4f5f-9824-6618614c1783" width="250" />|<img src="https://github.com/user-attachments/assets/7b865651-98fd-4f12-a425-b8518eca19a0" width="250" />

<br />

|마이슐랭 카테고리 설정| 마이슐랭 작성 | 마이슐랭 작성 |
|:--:|:--:|:--:|
|<img src="https://github.com/user-attachments/assets/7ea60c59-f1e2-426c-8c70-1398fd54716e" width="250" />|<img src="https://github.com/user-attachments/assets/180a52be-777c-4ed1-95f0-ffc97769287b" width="250" />|<img src="https://github.com/user-attachments/assets/33dcc02d-587a-471e-8af9-54ae14b490fa" width="250" />|

<br />

|마이페이지 - 마이슐랭 리스트 | 마이페이지 - 내가 찜한 마이슐랭|
|:--:|:--:|
|<img src="https://github.com/user-attachments/assets/1ff07ad4-4819-4d49-bddc-2e258eec9b1b" width="250" />|<img src="https://github.com/user-attachments/assets/5acd567a-5e5f-40a1-a845-edc6803e8bfd" width="250" />|
