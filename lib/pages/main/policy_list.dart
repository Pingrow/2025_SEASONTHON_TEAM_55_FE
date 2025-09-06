import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/model/region_model.dart';
import 'package:pin_grow/model/policy_model.dart';
import 'package:pin_grow/model/user_model.dart';
import 'package:pin_grow/providers/region_provider.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

enum TapStatus { notSelected, selected, load }

Map<TapStatus, Map<String, dynamic>> tapConfig = {
  TapStatus.notSelected: {
    "COLOR": 0xffF1F4F6,
    "FONT_COLOR": 0xffABABAB,
    "SHADOW": null,
  },
  TapStatus.selected: {
    "COLOR": 0xffFFFFFF,
    "FONT_COLOR": 0xff374151,
    "SHADOW": [
      BoxShadow(
        blurRadius: 3.0,
        color: Colors.black38,
        blurStyle: BlurStyle.normal,
        offset: Offset(0, 2.5),
      ),
    ],
  },
  TapStatus.load: {
    "COLOR": 0xffC3E4D8,
    "FONT_COLOR": 0xff374151,
    "SHADOW": [
      BoxShadow(
        blurRadius: 3.0,
        color: Colors.black38,
        blurStyle: BlurStyle.normal,
        offset: Offset(0, 2.5),
      ),
    ],
  },
};

Map<bool, Map<String, dynamic>> regionSelectConfig = {
  true: {
    // Selected
    "COLOR": 0x330fa564,
    "STROKE_COLOR": 0xff0CA361,
    "FONT_COLOR": 0xff374151,
  },
  false: {
    // NOT Selected
    "COLOR": 0xffF7F7F7,
    "STROKE_COLOR": 0xffF7F7F7,
    "FONT_COLOR": 0xffABABAB,
  },
};

class PolicyListPage extends StatefulHookConsumerWidget {
  const PolicyListPage({super.key});

  @override
  ConsumerState<PolicyListPage> createState() => _PolicyListPageState();
}

class _PolicyListPageState extends ConsumerState<PolicyListPage> {
  late List<bool> region_state;
  int idx = -1;
  int region_idx = -1;
  int area_idx = -1;

  List<TapStatus> tapStatus = [
    TapStatus.notSelected,
    TapStatus.notSelected,
    TapStatus.notSelected,
  ];

  List<String> apiLsit = [];

  late Future<List<PolicyModel>> _policyFuture;

  // 정책 리스트 불러오기
  Future<List<PolicyModel>> _fetchPolicyList() async {
    final response = await rootBundle.loadString(
      'assets/dummy/dummy_policy_list_gangnam.json',
    ); //await http.get(Uri.parse(''));

    if (true
    // response.statusCode == 200
    ) {
      final Map<String, dynamic> decodedJson = json.decode(
        response,
        /**.body */
      );
      final List<dynamic> policyListJson = decodedJson["policies"];
      final List<PolicyModel> policies = policyListJson
          .map((jsonItem) => PolicyModel.fromJson(jsonItem))
          .toList();
      return policies;
    } else {
      throw Exception('Failed to load policy list');
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('$urlString을(를) 열 수 없습니다.');
    }
  }

  @override
  void initState() {
    super.initState();
    region_state = [false, false, false];
    //await ref.read(regionProvider.notifier).getRegions();

    final authState = ref.read(authViewModelProvider);
    if (authState.user?.region?.split('-')[2] != 'NODATA') {
      idx = 2;
      region_idx = int.parse(authState.user?.region?.split('-')[0] ?? '-1');
      area_idx = int.parse(authState.user?.region?.split('-')[1] ?? '-1');

      tapStatus = [TapStatus.notSelected, TapStatus.load, TapStatus.load];
    }

    _policyFuture = _fetchPolicyList();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final regions = ref.watch(regionProvider);

    final Map<int, Map<TapStatus, Widget>> policiesForRegion = {
      0: {
        TapStatus.notSelected: Container(),
        TapStatus.selected: Container(),
        TapStatus.load: Container(),
      },
      1: {
        TapStatus.notSelected: Container(),
        TapStatus.selected: GridView.builder(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          itemCount: regions!.keys.length - 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 77.w / 47.h,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (region_idx == index) {
                    region_idx = -1;
                    return;
                  }

                  region_idx = index;

                  Timer(Duration(milliseconds: 200), () {
                    setState(() {
                      idx = 2;
                      tapStatus[2] = TapStatus.selected;
                    });
                  });
                });
              },
              child: Container(
                width: 77.w,
                height: 47.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(
                    regionSelectConfig[region_idx == index]!["COLOR"],
                  ),
                  border: Border.all(
                    color: Color(
                      regionSelectConfig[region_idx == index]!["STROKE_COLOR"],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  regions![regions.keys.elementAt(index)]!.alias,
                  style: TextStyle(
                    color: Color(
                      regionSelectConfig[region_idx == index]!["FONT_COLOR"],
                    ),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
        TapStatus.load: Container(),
      },
      2: {
        TapStatus.notSelected: Container(),
        TapStatus.selected: GridView.builder(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          itemCount: region_idx != -1
              ? regions != null
                    ? regions[regions?.keys.elementAt(region_idx)]?.areas.length
                    : 0
              : 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 77.w / 47.h,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                setState(() {
                  if (area_idx == index) {
                    area_idx = -1;
                    return;
                  }

                  area_idx = index;

                  Timer(Duration(milliseconds: 200), () {
                    setState(() async {
                      tapStatus[1] = TapStatus.load;
                      tapStatus[2] = TapStatus.load;

                      ref
                          .read(authViewModelProvider.notifier)
                          .setAuthState(
                            authState.status,
                            UserModel(
                              id: authState.user?.id,
                              nickname: authState.user?.nickname,
                              email: authState.user?.email,
                              profile_url: authState.user?.profile_url,
                              goal: authState.user?.goal,
                              goal_money: authState.user?.goal_money,
                              goal_period: authState.user?.goal_period,
                              research_completed:
                                  authState.user?.research_completed,
                              saved_money: authState.user?.saved_money,
                              type: authState.user?.type,
                              region:
                                  "$region_idx-$area_idx-${regions!.keys.elementAt(region_idx)}-${regions![regions.keys.elementAt(region_idx)]?.areas[area_idx]}", // 00-00-region-area {시도 인덱스}-{시군구 인덱스}-{시도 이름}-{시군구 이름}
                            ),
                          );

                      _policyFuture = _fetchPolicyList();
                    });
                  });
                });
              },
              child: Container(
                width: 77.w,
                height: 47.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(regionSelectConfig[area_idx == index]!["COLOR"]),
                  border: Border.all(
                    color: Color(
                      regionSelectConfig[area_idx == index]!["STROKE_COLOR"],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  regions![regions.keys.elementAt(region_idx)]!.areas[index],
                  style: TextStyle(
                    color: Color(
                      regionSelectConfig[area_idx == index]!["FONT_COLOR"],
                    ),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
        TapStatus.load: // 기존 build 메소드 내의 FutureBuilder 부분을 아래 코드로 교체하세요.
            // 데이터를 한 번만 로드하기 위한 단일 FutureBuilder
            FutureBuilder<List<PolicyModel>>(
              future: _policyFuture,
              builder: (context, snapshot) {
                // 1. 로딩 중 상태 처리
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. 에러 발생 상태 처리
                if (snapshot.hasError) {
                  return Center(child: Text('에러: ${snapshot.error}'));
                }

                // 3. 데이터가 없거나 비어있는 경우 처리
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('데이터가 없습니다.'));
                }

                // 4. 데이터 수신 성공 시 UI 구성
                final allPolicies = snapshot.data!;

                // 데이터를 안전하게 두 부분으로 나눔
                final popularPolicies = allPolicies.take(3).toList();
                final recommendedPolicies = allPolicies.skip(3).toList();

                // 전체를 스크롤 가능하게 만듦
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ), // 좌우 여백을 여기에 추가
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- 인기 정책 섹션 ---
                        Container(
                          margin: EdgeInsets.only(top: 25.h, bottom: 25.h),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Color(0xff374151),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(text: '지금 '),
                                TextSpan(
                                  text:
                                      '${regions[authState.user?.region?.split('-')[2]]!.alias} ${authState.user?.region?.split('-')[3]}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: ' 의 '),
                                const TextSpan(
                                  text: '인기 정책',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListView.builder(
                          padding: EdgeInsets.zero, // ListView의 기본 패딩 제거
                          physics:
                              const NeverScrollableScrollPhysics(), // 부모 스크롤과 충돌 방지
                          shrinkWrap: true, // ⭐ 핵심: 자식 높이만큼만 차지
                          itemCount: popularPolicies.length,
                          itemBuilder: (context, index) {
                            final policy = popularPolicies[index];
                            // 재사용 가능한 메소드 호출
                            return Container(
                              margin: EdgeInsets.only(bottom: 25.h),
                              child: Row(
                                children: [
                                  Container(
                                    width: 56.r,
                                    height: 56.r,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffABABAB),
                                      border: Border.all(
                                        color: const Color(0xff0CA361),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    // TODO: API 응답에 이미지가 있다면 Image.network(policy.imageUrl!) 등으로 교체
                                  ),
                                  SizedBox(width: 10.w), // 간격 조정
                                  Expanded(
                                    // 텍스트가 화면을 넘어갈 경우를 대비해 Expanded로 감싸줌
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            _popTag(),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                              child: Text(
                                                policy.sprvsnInstCdNm ??
                                                    '기관 정보 없음',
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(
                                                    0xff6B7280,
                                                  ),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          policy.plcyNm ?? '정책명 없음',
                                          style: TextStyle(
                                            color: const Color(0xff374151),
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/icons/eye.png',
                                              width: 7.r,
                                              height: 7.r,
                                            ),
                                            SizedBox(width: 3.w),
                                            Text(
                                              '${policy.incCnt ?? 0}',
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xff6B7280),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (policy.url != null &&
                                          policy.url!.isNotEmpty) {
                                        _launchUrl(policy.url!);
                                      }
                                    },
                                    child: Image.asset(
                                      policy.url != null &&
                                              policy.url!.isNotEmpty
                                          ? 'assets/icons/external_link_enabled.png'
                                          : 'assets/icons/external_link_disabled.png',
                                      width: 21.r,
                                      height: 21.r,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        // --- 추천 정책 섹션 (데이터가 있을 때만 표시) ---
                        if (recommendedPolicies.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top: 25.h,
                                  bottom: 25.h,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Color(0xff374151),
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${regions[authState.user?.region?.split('-')[2]]!.alias} ${authState.user?.region?.split('-')[3]}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const TextSpan(text: ' 의 이런 정책은 어떠신가요?'),
                                    ],
                                  ),
                                ),
                              ),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: recommendedPolicies.length,
                                itemBuilder: (context, index) {
                                  final policy = recommendedPolicies[index];
                                  // 동일한 메소드 재사용
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 25.h),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 56.r,
                                          height: 56.r,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffABABAB),
                                            border: Border.all(
                                              color: const Color(0xff0CA361),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          // TODO: API 응답에 이미지가 있다면 Image.network(policy.imageUrl!) 등으로 교체
                                        ),
                                        SizedBox(width: 10.w), // 간격 조정
                                        Expanded(
                                          // 텍스트가 화면을 넘어갈 경우를 대비해 Expanded로 감싸줌
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(width: 4.w),
                                                  Expanded(
                                                    child: Text(
                                                      policy.sprvsnInstCdNm ??
                                                          '기관 정보 없음',
                                                      style: TextStyle(
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                          0xff6B7280,
                                                        ),
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                policy.plcyNm ?? '정책명 없음',
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xff374151,
                                                  ),
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/eye.png',
                                                    width: 7.r,
                                                    height: 7.r,
                                                  ),
                                                  SizedBox(width: 3.w),
                                                  Text(
                                                    '${policy.incCnt ?? 0}',
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: const Color(
                                                        0xff6B7280,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (policy.url != null &&
                                                policy.url!.isNotEmpty) {
                                              _launchUrl(policy.url!);
                                            }
                                          },
                                          child: Image.asset(
                                            policy.url != null &&
                                                    policy.url!.isNotEmpty
                                                ? 'assets/icons/external_link_enabled.png'
                                                : 'assets/icons/external_link_disabled.png',
                                            width: 21.r,
                                            height: 21.r,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      },
    };

    ////////////////////////////////////////////////////////////////////

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(
        0,
        MediaQuery.of(context).padding.top,
        0,
        MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(color: Color(0xffffffff)),
      child: Column(
        children: [
          Container(
            width: 338.w,
            child: Column(
              children: [
                Container(
                  width: 338.w,
                  height: 39.h,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          GoRouter.of(context).pop();
                        },
                        child: Image.asset(
                          'assets/icons/back.png',
                          width: 10.w,
                          height: 16.h,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff374151),
                        ),
                        children: [
                          TextSpan(
                            text: authState.user?.nickname ?? '핀그로우',
                            style: TextStyle(color: Color(0xff0CA361)),
                          ),

                          TextSpan(text: ' 님을 응원하는 청년 정책'),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '지역을 선택하면, 딱 맞는 청년정책을 추천해드려요!',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          FittedBox(
            fit: BoxFit.fill,
            child: Container(
              width: 338.w,
              height: 47.h,
              margin: EdgeInsets.fromLTRB(0, 16.h, 0, 1.h),
              decoration: BoxDecoration(
                color: Color(0xffF1F4F6),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (tapStatus[0] == TapStatus.notSelected) {
                        setState(() {
                          idx = 0;
                          tapStatus[0] = TapStatus.selected;
                          tapStatus[1] = TapStatus.notSelected;
                          tapStatus[2] = TapStatus.notSelected;

                          region_idx = -1;
                          area_idx = -1;
                        });
                      }
                    },
                    child: Container(
                      width: 100.w,
                      height: 36.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(tapConfig[tapStatus[0]]!["COLOR"]),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: tapConfig[tapStatus[0]]!["SHADOW"],
                      ),
                      child: Text(
                        '전국',
                        style: TextStyle(
                          color: Color(tapConfig[tapStatus[0]]!["FONT_COLOR"]),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      if (tapStatus[1] == TapStatus.notSelected) {
                        setState(() {
                          idx = 1;
                          tapStatus[0] = TapStatus.notSelected;
                          tapStatus[1] = TapStatus.selected;
                          tapStatus[2] = TapStatus.notSelected;
                        });
                      }
                    },
                    child: Container(
                      width: 100.w,
                      height: 36.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(tapConfig[tapStatus[1]]!["COLOR"]),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: tapConfig[tapStatus[1]]!["SHADOW"],
                      ),
                      child: Text(
                        '시/도',
                        style: TextStyle(
                          color: Color(tapConfig[tapStatus[1]]!["FONT_COLOR"]),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      /**
                       * if (tapStatus[2] == TapStatus.notSelected) {
                        if (tapStatus[1] == TapStatus.notSelected) {
                          setState(() {
                            idx = 1;
                            tapStatus[0] = TapStatus.notSelected;
                            tapStatus[1] = TapStatus.selected;
                            //tapStatus[2] = TapStatus.selected;
                          });
                        } else {
                          setState(() {
                            idx = 2;
                            tapStatus[0] = TapStatus.notSelected;
                            //tapStatus[1] = TapStatus.notSelected;
                            tapStatus[2] = TapStatus.selected;
                          });
                        }
                      }
                       */
                    },
                    child: Container(
                      width: 100.w,
                      height: 36.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(tapConfig[tapStatus[2]]!["COLOR"]),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: tapConfig[tapStatus[2]]!["SHADOW"],
                      ),
                      child: Text(
                        '시/구/군',
                        style: TextStyle(
                          color: Color(tapConfig[tapStatus[2]]!["FONT_COLOR"]),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              width: 338.w,
              child: idx == -1
                  ? Container()
                  : policiesForRegion[idx]![tapStatus[idx]],
            ),
          ),
        ],
      ),
    );
  }

  Widget _popTag() {
    return Container(
      width: 34.w,
      height: 17.h,
      decoration: BoxDecoration(
        color: Color(0xffffeadb),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/fire.png', width: 10.r, height: 10.r),
          Text(
            '인기',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xff374151),
            ),
          ),
        ],
      ),
    );
  }
}
