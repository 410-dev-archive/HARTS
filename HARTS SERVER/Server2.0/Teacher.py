# 파일을 읽어옴: /tmp/HARTS/studentlist.harts
# 읽어온 데이터를 \n 으로 split 한 다음, 다시 ", " 로 join
# 메모리에 저장

# 파일을 읽어옴: /tmp/HARTS/test-url.harts
# 읽어온 데이터에서 \n 을 , 로 치환후 메모리에 저장

# 파일을 읽어옴: /tmp/HARTS/session.harts
# 읽어온 데이터를 \n 으로 split 한 후, 0번 인덱스 값을 세션 공개키로, 1번 인덱스 값을 비공개키로 메모리에 저장

# 메인 서버로 접속 시도

# 접속 성공시 다음과 같은 패킷을 전송
# [PRCTR]:[SESSION_BUILD]:세션공개키//세션비공개키//테스트URL//학생 이름 리스트

# 리턴에서 [SERVER]:[OK] 가 들어올 경우 서버로부터 데이터 수신 대기 상태로 진입
# 아닐 경우 오류 파일 생성 후 리턴값 작성: /tmp/HARTS/sessionmake-request-failed

