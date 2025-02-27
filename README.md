# Mychelin (마이슐랭)

나만의 맛집을 마이슐랭에 등록하고 위치 기반으로 다른 유저의 마이슐랭을 수집하는 앱

<br />

### 목차

- [프로젝트 소개](#-프로젝트-소개)

<br />

### 프로젝트 소개

- 개발 인원 : 강한결 (1인 프로젝트, 백엔드 개발자 서버 협업)
- 기간 : 2025.01.24 ~ 02.14 (3주)
- 최소 버전 : iOS 16.0
- 주요 기능
  - 나만의 맛집을 검색하고 위치 기반으로 후기를 남길 수 있습니다.
  - 나의 위치를 중심으로 나의/다른 유저의 맛집 후기를 확인할 수 있습니다.
  
### 프로젝트 아키텍처 및 스택

| 스택 | 활용 |
|:-|:-|
| **ReactorKit** | View - Reactor 기반 단방향 데이터 플로우 아키텍처 |
| **Tuist** | 프로젝트 설정 및 모듈 분리 |
| **UIKit, SnapKit** | 컴포넌트 및 레이아웃 구현 |
| **RxSwift** | View 이벤트 처리 및 상태 데이터 흐름 관리 |
| **RxDataSource** | Section별 CollectionView, TableView 데이터 모델 구성 |
| **Moya** | 네트워크 객체 구성 및 통신 |
| **NAVER MAP API** | 지도 UI 및 위치 데이터 활용 |

<br />

### 프로젝트 구현 화면

| 홈 - 마이슐랭 지도 | 홈 - 마이슐랭 선택 | 마이슐랭 디테일 |
|:--:|:--:|:--:|
|<img src="https://github.com/user-attachments/assets/389d3492-0808-4e87-ac5d-d151e92840c3" width="250" />|<img src="https://github.com/user-attachments/assets/0330bf4a-865f-4f5f-9824-6618614c1783" width="250" />|<img src="https://github.com/user-attachments/assets/7b865651-98fd-4f12-a425-b8518eca19a0" width="250" />

<br />

|마이슐랭 카테고리 설정| 마이슐랭 작성 | 마이슐랭 작성 |
|:--:|:--:|:--:|
|<img src="https://github.com/user-attachments/assets/34d659d5-9a5f-48ed-afbb-a99d830be501" width="250" />|<img src="https://github.com/user-attachments/assets/6e0c3d77-e25f-4dc2-99fe-f9d1109bde93" width="250" />|<img src="https://github.com/user-attachments/assets/c5cffc98-5a3b-4988-85f4-812a2bb4d2a4" width="250" />

<br />

|마이페이지 - 마이슐랭 리스트 | 마이페이지 - 내가 찜한 마이슐랭|
|:--:|:--:|
|<img src="https://github.com/user-attachments/assets/1ff07ad4-4819-4d49-bddc-2e258eec9b1b" width="250" />|<img src="https://github.com/user-attachments/assets/5acd567a-5e5f-40a1-a845-edc6803e8bfd" width="250" />|

