# Familiar-terraform

Familiar Project의 테라폼 소스 코드입니다.

**Git Clone**
```Bash
git clone https://github.com/Familiar-org/Familiar-terraform.git
```

## 1. 소스 코드 구조

모듈 구조를 잡는데는 공식 문서의 [링크](https://developer.hashicorp.com/terraform/language/modules/develop/structure)를 참조하게 되었다. 해당 링크에는 테라폼의 기본적인 모듈 구조가 서술되어 있다.

또한 각각의 환경으로 분리하고 Medium size infrastructure를 프로비저닝하기 위해서 [링크](https://ibatulanand.medium.com/the-right-way-to-structure-terraform-project-89a52d67e510)를 참조하게 되었다.

구조는 아래와 같다.

```Bash
# Terraform Tree 구조
# 완료 시 작성 예정
```


## 2. Git

**Git Flow**
Git Flow의 경우에는 흔히 생각하고 있는 Git Flow로 구성하게 되었다.

![Git Flow](https://wac-cdn.atlassian.com/dam/jcr:a13c18d6-94f3-4fc4-84fb-2b8f1b2fd339/01%20How%20it%20works.svg?cdnVersion=1874)

위와 같은 구조로 main, dev branch를 주축 branch로 두고 feature, release, hotfix를 상황에 맞게 사용할 예정이다.

**Git Commit Convention**

Commit Convention의 경우 아래의 글들을 참고해 작성했다.

- [https://www.conventionalcommits.org/en/v1.0.0/](https://www.conventionalcommits.org/en/v1.0.0/)
- [https://velog.io/@archivvonjang/Git-Commit-Message-Convention](https://velog.io/@archivvonjang/Git-Commit-Message-Convention)
- [https://github.com/nhn/tui.chart/blob/main/docs/COMMIT_MESSAGE_CONVENTION.md](https://github.com/nhn/tui.chart/blob/main/docs/COMMIT_MESSAGE_CONVENTION.md)

## 3. 의사 결정

### 3.1 모듈 구조

모듈 구조의 경우 /environment를 기준으로 환경별로 나누어 dev, prod로 나누고, 공통 모듈을 /modules에 작성해 공통 모듈을 통해 환경별 리소스를 작성할 수 있도록 했다.

아래의 글들을 참고하게 되었다.

- [https://developer.hashicorp.com/terraform/language/modules/develop/structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)
- [https://www.terraform-best-practices.com/examples/terraform/medium-size-infrastructure](https://www.terraform-best-practices.com/examples/terraform/medium-size-infrastructure)
- [https://www.reddit.com/r/Terraform/comments/tto5h3/terraform_folder_structure/](https://www.reddit.com/r/Terraform/comments/tto5h3/terraform_folder_structure/)
- [https://blog.devops.dev/how-to-manage-multiple-environments-with-terraform-with-the-use-of-modules-d4ca512d7b4a](https://blog.devops.dev/how-to-manage-multiple-environments-with-terraform-with-the-use-of-modules-d4ca512d7b4a)
 

### 3.2 Backend

Backend의 경우 S3로 하고 각 Env 별로 S3 key 기반으로 /dev, /prod 로 나누어 관리할 예정이다.

Backend의 S3 bucket은 콘솔에서 생성 했으며 chicken and egg problem 이라고 불리우는 문제를 해결하기 위해 생성된 S3 bucket을 import 할 것이다.

**Chickend and egg problem**
- [https://discuss.hashicorp.com/t/chicken-and-egg-the-terraform-remote-state-s3-bucket-cannot-be-idempotent-if-created-by-terraform/21880](https://discuss.hashicorp.com/t/chicken-and-egg-the-terraform-remote-state-s3-bucket-cannot-be-idempotent-if-created-by-terraform/21880)
- [https://mmatecki.medium.com/terraform-chicken-egg-problem-7504f8ddf2fc](https://mmatecki.medium.com/terraform-chicken-egg-problem-7504f8ddf2fc)
- [https://github.com/orgs/gruntwork-io/discussions/769](https://github.com/orgs/gruntwork-io/discussions/769)

