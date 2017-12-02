![logo_wide](https://github.com/setariaOS/setaria/blob/master/logo.png)
# setaria
x86 아키텍쳐를 위한 운영체제

## 빌드
setaria를 빌드하기 위해서는 다음 프로그램들이 필요합니다(프로그램 이름 오른쪽에 쓰여진 버전은 빌드가 정상적으로 되는 것을 확인한 버전입니다.):
- [g++](https://gcc.gnu.org/) 5.4.1
- [Ld](https://gcc.gnu.org/) 2.26.1
- [NASM](http://www.nasm.us/) 2.11.08
- [Python](https://www.python.org/) 2.7.12 and 3.5.2

다음 명령어를 setaria 디렉터리로 이동하여 순서대로 입력하면 빌드할 수 있습니다.
### x86-64
```
$ python ./make.py -m64
$ make
```

## 감사한 분들
- [李](https://github.com/Lee0701) - 로고 디자인

## 저작권
- setaria는 MIT 라이선스를 채택하고 있습니다. MIT 라이선스로 라이선스를 전환하기 전의 커밋들도 MIT 라이선스가 적용됩니다.
- setaria 로고의 저작권은 [李](https://github.com/Lee0701)님께 있습니다.