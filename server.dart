import 'dart:convert';
import 'dart:io';

String HOST = '0.0.0.0'; // 서버 호스트
int PORT = 4001; // 서버 포트
List<dynamic> clients = []; // 클라이언트 목록

const String BOT_USERNAME = "Bot";

void broadcastBotMessage(String message) {
  final botMessage = jsonEncode({
    'type': 'all|message',
    'username': BOT_USERNAME,
    'message': message,
  });

  print("봇 메시지 발송: $message");

  // 접속 중인 모든 클라이언트에게 메시지를 보냅니다.
  for (var client in clients) {
    client[0].add(botMessage);
  }
}

void main() async {
  // 서버 설정
  HttpServer server = await createServer();

  // 클라이언트 요청 및 메시지 처리
  clientConnections(server);
}

// 서버 생성
createServer() {
  print("서버가 생성되었습니다. $HOST:$PORT");
  return HttpServer.bind(HOST, PORT);
}

// 클라이언트 요청 및 메시지 처리
clientConnections(HttpServer server) async {
  // 클라이언트 요청 비동기 처리
  await for (var req in server) {
    // HTTP 요청을 웹 소켓 프로토콜로 업그레이드
    await WebSocketTransformer.upgrade(req).then((WebSocket websocket) async {
      // 디버그용 클라이언트 식별 print
      print("클라이언트 접속 : ${req.connectionInfo!.remoteAddress.address}");

      // 클라이언트 통신
      await webSocketActions(websocket);
    });
  }
}

// 클라이언트 초기 접속 정보 저장
addClient(client, username) {
  print("클라이언트 접속 정보 : username($username)");
  clients.add([client, username]);

  broadcastBotMessage('안녕하세요! 핀그로우 챗봇입니다. 어떤 금융 경제 용어가 궁금하신가요?');
}

// 클라이언트 연결 종료 시 서버 목록에서 제거
removeClient(WebSocket websocket) {
  for (var i = 0; i < clients.length; i++) {
    var client = clients[i];
    if (client[0] == websocket) {
      print("클라이언트 대화목록 : ${client[0].toString()}");

      print("클라이언트 접속 종료 : ${client[1]}");
      clients.removeAt(i); // 해당 클라이언트 목록에서 제거
      print("접속중인 클라이언트 목록 : $clients");
      break; // 클라이언트를 찾았으므로 반복문 종료
    }
  }
}

// 클라이언트와 상호작용하는 함수
webSocketActions(WebSocket websocket) {
  // 클라이언트로 받은 데이터 메시지 처리
  websocket.listen(
    (data) {
      // JSON 데이터 파싱
      var dataInfo = convertToJson(data);
      String messageType = dataInfo['type'].split("|")[0];

      // 초기 접속 시 클라이언트 접속 정보 저장
      if (messageType == "init") {
        addClient(websocket, dataInfo['username']);

        webSocketListen(websocket, jsonEncode(data));
      }
      // 연결되어 있는 클라이언트에게 보낼 데이터 송신 처리
      else {
        webSocketListen(websocket, data);
      }
    },
    // 클라이언트 연결 종료 시 서버 목록에 제거
    onDone: () {
      removeClient(websocket);
    },
    // 에러 처리
    onError: (e) {
      print("[server.dart] (webSocketActions) onError : $e");
    },
  );
}

// JSON 데이터 파싱 함수
convertToJson(data) {
  if (data is! String) {
    print("경고: 파싱할 데이터가 문자열이 아닙니다. (타입: ${data.runtimeType})");
    return null;
  }

  try {
    var decoded = jsonDecode(data);
    // 디코딩 결과가 Map 형태인지 확인
    if (decoded is Map<String, dynamic>) {
      return decoded;
    } else {
      print("경고: JSON 파싱 결과가 Map이 아닙니다. (타입: ${decoded.runtimeType})");
      return null;
    }
  } catch (e) {
    print("에러: JSON 파싱 중 예외 발생. 데이터: $data, 에러: $e");
    return null;
  }
}

// 클라이언트로 받은 데이터 메시지 처리
webSocketListen(WebSocket websocket, data) {
  // JSON 데이터 파싱
  print("클라이언트로부터의 메시지 : $data");
  var dataInfo = convertToJson(data);
  if (dataInfo == null) {
    return;
  }

  String messageType = dataInfo['type'].split("|")[0];

  for (var client in clients) {
    if (messageType == "all") {
      client[0].add(data);
    }
  }
}
