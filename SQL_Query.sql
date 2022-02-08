#DROP DATABASE musicmate;
CREATE DATABASE musicmate;
USE musicmate;

#장르 테이블
CREATE TABLE genre (장르번호 INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 장르 VARCHAR(20));
INSERT INTO genre (장르) VALUES ('Balad'), ('Dance'), ('Indi'),('OST'),('R&B'),('Rap'),('Rock');

#유저 테이블
CREATE TABLE user( 회원번호 int not null auto_increment primary key, 이름 varchar(50), 아이디 varchar(50), 비밀번호 varchar(50), 장르번호 int, foreign key(장르번호) references genre(장르번호));

#관리자 정보
INSERT INTO user VALUES (0, '관리자', 'chltmdwo764', '00chla', 6);

#노래 테이블
create table music
(노래번호 int not null auto_increment primary key,
 제목 varchar(100),
 좋아요 int,
 가수 varchar(100),
 장르번호 int,
 발매일 date,
 foreign key(장르번호) references genre(장르번호)
);
insert into music
(제목, 가수, 발매일, 장르번호, 좋아요)
values
('180도', '벤', '2018-12-07', 1,3215),
('아낙네','송민호','2018-11-26',6,3200),
('SOLO', '제니', '2018-11-12', 6, 3198),
('YES or YES', ' 트와이스', '2018-11-05', 2, 3195),
('삐삐', '아이유', '2018-10-10', 5, 3193),
('가을 타나 봐', '바이브', '2018-09-18',1,3021),
('흔한 이별', '허각', '2018-11-28', 1, 3011),
('아름답고도 아프구나', '비투비', '2018-11-12', 1,3010),
('봄바람', '워너원', '2018-11-19',2,2986),
('고백', '양다일', '2018-10-15',1,2865), #10
('하루도 그대를 사랑하지 않은 적이 없었다','임창정','2018-09-19',1,2863),
('Tempo', '엑소', '2018-11-02', 2,2860),
('모든 날, 모든 순간', '폴킴', '2018-3-20',1,2850),
('내 생에 아름다운', '케이윌', '2018-10-23', 1, 2843),
('Good Day','키드밀리','2018-10-06',6,2840),
('Way Back Home', '숀', '2018-06-27',2,2760),
('시간이 들겠지', '로꼬', '2018-10-08',6,2750),
('멋지게 인사하는 법', '자이언티', '2018-10-15', 1, 2743),
('열애중','벤','2018-05-08',1,2742),
('이별하러 가는 길', '임한별', '2018-09-13', 1, 2740),
('우리 그만하자', '로이킴', '2018-09-18', 1, 2733),
('헤어지는 중', '펀치', '2018-09-12', 5, 2722),
('라비앙로즈','아이즈원', '2018-10-29', 2, 2713),
('사이렌', '선미', '2018-09-04', 2, 2703),
('꿈처럼 내린', '다비치', '2018-10-16', 4, 2692),
('생각보다 더 빨리','픽션들', '2018-11-21', 1, 2531),
('IndiGO','키드밀리', '2018-06-24',6,2512),
('IDOL','방탄소년단','2018-08-24',6,2503),
('이별길','아이콘','2018-10-01',1,2489),
('지나오다','닐로','2017-10-31',1,2488),
('Save','루피', '2018-10-20', 6, 2480),
('뚜두뚜두','블랙핑크','2018-06-15',6,2477),
('It\'s You','샘김','2018-11-22',5,2470),
('수퍼비와','슈퍼비','2018-11-03',6,2465),
('Bohemian Rhapsody', 'Queen','1992-03-01',7,2455),
('미안해','양다일','2017-12-29',5,2451),
('flex','기리보이','2018-07-31',6,2430),
('가을 안부','먼데이키즈', '2017-10-14', 1, 2421),
('밤편지','아이유','2017-03-24',1,2413),
('아이','픽션들','2018-09-05',7,2405),
('Dance The Night Away','트와이스','2018-07-09',2,2395),
('비','폴킴','2016-06-21',5,2390),
('신용재','하은','2018-11-06',1,2386),
('Gravity','엑소','2018-11-02',2,2256),
('집','워너원','2018-11-19',2,2249),
('Goodbye','웬디','2018-11-06',1,2246),
('너 없인 안 된다 ','비투비','2018-06-18',1,2243),
('그리워하다','비투비','2017-10-16',1,2230),
('사임사임','슈퍼비','2018-10-06',6,2225),
('너는 어땠을까','노을','2018-11-05',1,2219),
('FAKE LOVE','방탄소년단','2018-05-18',6,2213); #51개 

#가수 테이블 만들기
CREATE TABLE singers(가수번호 INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 가수 VARCHAR(50));
INSERT INTO singers (가수) SELECT DISTINCT 가수 FROM music;
ALTER TABLE music ADD 가수번호 int, ADD FOREIGN KEY(가수번호) REFERENCES singers(가수번호);
UPDATE music m SET 가수번호 = (SELECT 가수번호 FROM singers s WHERE m.가수 = s.가수);
ALTER TABLE music DROP 가수;


#관리자 플레이리스트
CREATE TABLE playlist0 ( 순서 int not null auto_increment primary key, 노래번호 int, foreign key(노래번호) references music(노래번호));

#가사 테이블
create table lyrics (노래번호 int ,가사 LONGTEXT, foreign key(노래번호) references music(노래번호));
ALTER TABLE lyrics
add primary key(노래번호);
insert into lyrics
values
(1, '사랑 다 비슷해 그래 다 비슷해
너는 다르길 바랐는데
넌 뭐가 미안해 왜 맨날 미안해
헤어지는 날조차 너는 이유를 몰라
이젠 180도 달라진
너의 표정 그 말투
너무 따뜻했던 눈빛 네 향기까지도
정말 너무나도 달라진
우리 사랑 또 추억
아직 그대로인데 난
이젠 180도 변해버린
지금 너와 나
남자는 다 비슷해 그래 다 비슷해
너는 아니길 바랐는데
말로만 사랑해 거짓말 그만해
헤어지는 날조차 왜 넌 이유를 몰라
이젠 180도 달라진
너의 표정 그 말투
너무 따뜻했던 눈빛 네 향기까지도
정말 너무나도 달라진
우리 사랑 또 추억
아직 그대로인데 난
이젠 180도 변해버린
지금 너와 나
사랑해 말하지 않아도
너의 눈에 쓰여 있었던
그때가 참 그리워
이젠 180도 변해버린
너와 나의 약속
익숙해진 변명 거짓말까지도
모두 진심이라 믿었던
바보 같던 내 사랑
전부 지쳐버렸어 난
이젠 180도 변해버린
지금 너와 나
이젠 너무나도 그리워진
그때 너와 나'),
(2, '똑똑 그대 보고 싶소 넘볼 수 없고 가질 수 없어 (So, sad)
뚝뚝 눈물 쏟아내도 그 고운 자태 한 번 비추지 않고 (너무해에)
내게만 까칠한 그녀는 유명한 화이
서울의 별 다 어딨나 Oh, in your eyes 
걔와 함께면 넌 디스토피아, 내 발걸음 따라오면 유토피아

Pretty woman
워 워 귀티나네
이리 봐도 저리 봐도 이뻐 이뻐 넌

나의 아낙네 이제 알았네
아낙네 나의 파랑새 (Woo yeah)

꼭꼭 숨어라 나의 님 (나의 님)
머리카락 보일라 어딨니 (Where are you?)
못 찾겠다 꾀꼬리 (꾀꼬리)
그대 있는 곳으로 가리, 나 가리

쉿 아무 말 하지 말고 도망치자 멀리
나만 보고 이제 그만해 제비뽑기
한여름에도 걷고 싶어 너의 그 눈길 
우리 둘이 야리꾸리 무리무리 Oh
그리워 너의 몸, 그리고 외로워 
여기 밑 빠진 Dog 물 맥여 줘
배배 꼬아 마치 코브라 부끄러워마, Alright?

Pretty woman
워 워 귀티나네
이리 봐도 저리 봐도 이뻐 이뻐 넌

나의 아낙네 이제 알았네
아낙네 나의 파랑새 (Woo yeah)

꼭꼭 숨어라 나의 님 (나의 님)
머리카락 보일라 어딨니 (Where are you?)
못 찾겠다 꾀꼬리 (꾀꼬리)
그대 있는 곳으로 가리, 나 가리

너는 그림 속의 움츠린 떡, Woo 난 침이 꿀꺽
넌 나의 주인공, 난 너의 츄잉껌
Woo, let\'s boogie on & on

우린 불이 튀어, 이제 숨통이 틔어, 영원히 네게 충성
아름다운 넌 이뻐, 이뻐 

랄라라라랄라 랄랄라 
랄라라라랄라 랄랄라
랄라라라랄라 랄랄라라
Where ma bishes at 내 아낙네

꾀꼬리 (삐요삐요삐요)
나, 가리 (엥엥엥)
꾀꼬리 (삐요삐요삐요)
그대 있는 곳으로 가리
나가리'),
(3,'천진난만 청순가련
새침한 척 이젠 지쳐 나
귀찮아
매일 뭐 해 어디야 밥은 잘 자
Baby 자기 여보 보고 싶어
다 부질없어
You got me like
이건 아무 감동 없는
Love Story
어떤 설렘도 어떤 의미도
네겐 미안하지만
I\'m not sorry
오늘부터 난 난 난
빛이 나는 솔로
빛이 나는 솔로
I\'m going solo lo lo lo lo lo
I\'m going solo lo lo lo lo lo
Used to be your girl
Now I\'m used to
being the GOAT
You\'re sittin\' on your feelings
I\'m sittin\' on my throne
I ain\'t got no time
for the troubles in your eyes
This time I\'m only lookin\' at me
myself and I
I\'m going solo
I\'ma do it on my own now
Now that you\'re alone
got you lookin\' for a clone now
So low
That\'s how I\'m gettin\' down
Destined for this and the crown
Sing it loud like
이건 아무 감동 없는
Love Story
어떤 설렘도 어떤 의미도
네겐 미안하지만
I\'m not sorry
오늘부터 난 난 난
빛이 나는 솔로
빛이 나는 솔로
I\'m going solo lo lo lo lo lo
I\'m going solo lo lo lo lo lo
만남 설렘 감동 뒤엔
이별 눈물 후회 그리움
홀로인 게 좋아 난 나다워야 하니까
자유로운 바람처럼
구름 위에 별들처럼
멀리 가고 싶어 밝게 빛나고 싶어
빛이 나는 솔로
I\'m going solo lo lo lo lo lo
I\'m going solo lo lo lo lo lo'),
(4,'Hey boy 
Look I\'m gonna make 
this simple for you 
you got two choices 
YES or YES 
Ah 둘 중에 하나만 골라 
YES or YES 
Ah ah 하나만 선택해 어서 
YES or YES 
내가 이렇게도 이기적이었던가 
뭔가 이렇게 갖고 싶던 적 있었나 
다 놀라 내 뻔뻔함에 
Come on and tell me yes 
생각보다 과감해진 나의 시나리오 
이 정도 Plan이면 완벽해 만족해 
I don\'t care 누가 뭐래도 
You better tell me yes 
내 맘은 정했어 YES 
그럼 이제 네 대답을 들을 차례 
힘들면 보기를 줄게 넌 고르기만 해 
고민할 필요도 없게 해줄게 
뭘 고를지 몰라 준비해봤어 
둘 중에 하나만 골라 YES or YES 
네 마음을 몰라 준비해봤어 
하나만 선택해 어서 YES or YES 
싫어는 싫어 나 아니면 우리 
선택을 존중해 거절은 거절해 
선택지는 하나 자 선택은 네 맘 
It\'s all up to you 
둘 중에 하나만 골라 YES or YES 
진심일까 Do not guess 
진심이니 Do not ask 
애매한 좌우 말고 확실히 위아래로 
There\'s no letters N & O 
지워버릴래 오늘부로 
복잡하게 고민할 필요 
없어 정답은 YES YES YO 
없던 이기심도 자극하는 
너의 눈과 
널 향한 호기심이 만나서 
타올라 타오른다 
My heart burn burn burn 
조금 쉽게 말하자면 
넌 뭘 골라도 날 만나게 될 거야 
뭐 좀 황당하긴 해도 
억지라고 해도 
절대 후회하지 않게 해줄게 
뭘 고를지 몰라 준비해봤어 
둘 중에 하나만 골라 YES or YES 
네 마음을 몰라 준비해봤어 
하나만 선택해 어서 YES or YES 
싫어는 싫어 나 아니면 우리 
선택을 존중해 거절은 거절해 
선택지는 하나 자 선택은 네 맘 
Now it\'s all up to you 
Maybe not 
No No 
Maybe yes 
No No 
좀 더 선명하게 네 맘을 내게 보여봐 
귀 기울여봐 
무슨 소리가 들리지 않니 
It\'s Simple Y E S Hey 
둘 중에 하나만 골라 YES or YES 
하나만 선택해 어서 YES or YES 
하나 더 보태서 YES or YES or YES 
골라봐 자 선택은 네 맘 
뭘 고를지 몰라 준비해봤어 
둘 중에 하나만 골라 YES or YES 
네 마음을 몰라 준비해봤어 
하나만 선택해 어서 YES or YES 
싫어는 싫어 나 아니면 우리 
선택을 존중해 거절은 거절해 
선택지는 하나 자 선택은 네 맘 
It\'s all up to you
하나만 선택해 어서 YES or YES'),
(5,'Hi there
인사해 호들갑 없이
시작해요 서론 없이
스킨십은 사양할게요
back off back off
이대로 좋아요
balance balance
It\'s me 나예요 다를 거 없이
요즘엔 뭔가요 내 가십
탐색하는 불빛
scanner scanner
오늘은 몇 점인가요
jealous jealous
쟤는 대체 왜 저런 옷을 좋아한담
기분을 알 수 없는 저 표정은 뭐람
태가 달라진 건
아마 스트레스 때문인가
걱정이야 쟤도 참
Yellow C A R D
이 선 넘으면 침범이야 beep
매너는 여기까지
it\'s ma ma ma mine
Please keep the la la la line
Hello stuP I D
그 선 넘으면 정색이야 beep
Stop it 거리 유지해
cause we don\'t know know know know
Comma we don\'t owe owe owe owe
anything
I don\'t care
당신의 비밀이 뭔지
저마다의 사정 역시
정중히 사양할게요
not my business
이대로 좋아요
talk talkless
Still me 또예요
놀랄 거 없이
I\'m sure you\'re gonna say
my gosh
바빠지는 눈빛
checki cheking
매일 틀린 그림 찾기
hash tagging
꼿꼿하게 걷다가 삐끗 넘어질라
다들 수군대는 걸 자긴 아나 몰라
요새 말이 많은 걔랑 어울린다나
문제야 쟤도 참
Yellow C A R D
이 선 넘으면 침범이야 beep
매너는 여기까지
it\'s ma ma ma mine
Please keep the la la la line
Hello stuP I D
그 선 넘으면 정색이야 beep
Stop it 거리 유지해
cause we don\'t know know know know
Comma we don\'t owe owe owe owe
anything
편하게 하지 뭐
어 거기 너 내 말 알아 들어 어
I don\'t believe it
에이 아직 모를 걸
내 말 틀려 또 나만 나뻐 어
I don\'t believe it
깜빡이 켜 교양이 없어 너
knock knock knock
Enough 더 상대 안 해
block block block block block
잘 모르겠으면
이젠 좀 외워 babe
Repeat repeat
참 쉽지 right
Yellow C A R D
이 선 넘으면 침범이야 beep
매너는 여기까지
it\'s ma ma ma mine
Please keep the la la la line
Hello stuP I D
그 선 넘으면 정색이야 beep
Stop it 거리 유지해
cause we don\'t know know know know
Comma we don\'t owe owe owe owe
anything'), #삐삐
(6,'계절은 돌고 돌아 돌아오는데
사랑은 돌고 돌아 떠나버리고
추억을 돌고 돌아 멈춰 서있는
다시 그 계절이 왔나 봐
나 가을 타나 봐
니가 그리워진 이 밤
나 혼자 널 기다리나 봐
나 가을 타나 봐
니가 불어오는 이 밤
나 혼자서 가을 타나 봐
Baby I\'m lonely lonely
lonely lonely
추억은 Falling falling
falling falling
아무리 멀리 멀리 떠나 보내도
돌아오는 난 가을 타나 봐
내 곁을 스쳐가는 많은 사람들
뭘 해도 채워지지 않는 시간들
아무리 잊어봐도 짙어져 가는
외로운 계절이 왔나 봐
나 가을 타나 봐
니가 그리워진 이 밤
나 혼자 널 기다리나 봐
나 가을 타나 봐
니가 불어오는 이 밤
나 혼자서 가을 타나 봐
Baby I\'m lonely lonely
lonely lonely
추억은 Falling falling
falling falling
아무리 멀리 멀리 떠나 보내도
돌아오는 난 가을 타나 봐
You\'re always breathing
in my mind
가슴 한구석이 시려와
Baby I\'m missing you every night
니가 그리워
나 외로웠나 봐
니가 없는 이 거리에
나 혼자 널 서성이나 봐
참 보고 싶나 봐 너를 보내놓고
아직 나 혼자 널 사랑하나 봐
아직인가 봐 사랑하나 봐
니가 날 떠나가던 시린
이 계절이 돌아오면 가을 타나 봐
그리운가 봐 가을 타나 봐'), # 가을타나봐
(7,'매일 집으로 돌아가는 
익숙한 골목 거리 사이
불어온 볼 스치는 
차가워진 이 바람을 따라
걷다가 네 생각이 나 잘 지내니
많이 바쁘게 지냈나 봐 
너 없는 하루가 왜 그리
느리게만 가는지 했던 게 
어제 일만 같은데
어느새 까맣게 잊고 살았나 봐
이 계절이 널 기억하고 있나 봐
우리가 헤어진 게 이맘때였어
그때는 왜 그렇게 
세상을 다 잃은 것만 같던지
지나 지나고 보니
흔한 이별인 듯 살아져
너도 나처럼 어느새 잊었을까
참 사랑했었던 애틋했던 
우리 사이 이젠
남들과 같나 봐
지나보니 알 것 같아 
다 내 잘못이었다는 걸
들릴 듯 말 듯하게 
나 혼잣말로 미안했다며
별일은 없는지 너를 불러봐
이 계절이 널 기억하고 있나 봐
우리가 헤어진 게 이맘때였어
그때는 왜 그렇게 
세상을 다 잃은 것만 같던지
지나 지나고 보니
흔한 이별인 듯 살아져
너도 나처럼 어느새 잊었을까
참 사랑했었던 애틋했던 
우리 사이 이젠
남들과 같나 봐
생각보다 많이 무뎌진 것만 같아서
조심스레 괜찮다 말해
볼 스치는 바람 따라 
살며시 너를 싣고서
이젠 보내줄래'),
(8,'사랑을 만나 이별을 하고
수없이 많은 날을 울고 웃었다
시간이란 건 순간이란 게
아름답고도 아프구나
낭만 잃은 시인 거의 시체 같아
바라고 있어 막연한 보답
아픔을 피해 또 다른 아픔을 만나
옆에 있던 행복을 못 찾았을까
너를 보내고 얼마나
나 많이 후회했는지 몰라
지금 이 순간에도 많은 걸
놓치고 있는데 말이야
시간은 또 흘러 여기까지 왔네요
지금도 결국 추억으로 남겠죠
다시 시작하는 게 이젠 두려운걸요
이별을 만나 아플까 봐
사랑을 만나 이별을 하고
수없이 많은 날을 울고 웃었다
시간이란 건 순간이란 게
아름답고도 아프구나
Yeah love then pain love then pain
Yeah let\'s learn from our mistakes
우린 실패로부터 성장해 
성장해
사랑은 하고 싶지만
Nobody wants to deal 
with the pain that follows no
I understand them though
Yeah 이해돼 이해돼 
사랑이라는 게
매일 웃게 하던 게 
이제는 매일 괴롭게 해 
괴로워
아픈 건 없어지겠지만 
상처들은 영원해
But that\'s why it\'s called 
beautiful pain
시간은 슬프게 기다리질 않네요
오늘도 결국 어제가 되겠죠
다시 시작하는 게
너무나 힘든걸요
어김없이 끝이 날까 봐
사랑을 만나 이별을 하고
수없이 많은 날을 울고 웃었다
시간이란 건 순간이란 게
아름답고도 아프구나
사랑이란 건 멈출 수 없다 
아픔은 반복돼
이렇게도 아픈데 또 찾아와 
사랑은 남몰래
우린 누구나가 바보가 돼
무기력하게도 한순간에
오래도록 기다렸다는 듯
아픈 사랑 앞에 물들어가
그대를 만나 사랑을 하고
그 어떤 순간보다 행복했었다
그대는 부디 아프지 말고
아름다웠길 바란다
사랑을 만나 이별을 하고 
수없이 많은 날을 울고 웃었다
시간이란 건 순간이란 게
아름답고도 아프구나'),
(9,'너와 내가 만나서
우리가 된 건 기적
다 꿈인 것만 같아
눈 감아도
선명하게 보여
더 잘해주지 못해
자꾸만 후회가 돼
내 맘은 그게 아닌데
늘 같이 있고 싶은데
긴 터널을 지나
밝은 빛을 볼 때
함께 느꼈던 따뜻한 기억들
늘 내 편이 되어
날 빛나게 만들어 주던
만들어 주던
그 미소 그 눈물 Uh
날 불러주던 목소리
귀를 자꾸 맴돌겠지
마주 보던 서로의 눈빛이
그립겠지만
사랑 설렘 첫 느낌 선명히 남아
우리 다시 만나
봄바람이 지나가면
환하게 웃을게
봄바람이 지나가면
우리 다시 만나
봄바람이 지나가면
한 번 더 안아줄게
봄바람이 지나가면 그때라면
미안 미안
늘 받기만 한 것 같아서
고마워 고마워
아름다워 줘서
텅 빈 내 맘을 넌 덮어
가득 너로 채워 줘서
지친 내게 손을 내밀어
너만이 날 숨 쉬게 만들어
이젠 매일매일 생일 Birthday
난 새로 태어난 채로 Up
늘 내 편이 되어
날 빛나게 만들어 주던
만들어 주던
그 미소 그 눈물 Uh
익숙한 너의 모습이
어쩌면 변해가겠지
마주 보던 우리의 기억은
지금 이대로
사랑 설렘 첫 느낌 선명히 남아
우리 다시 만나
봄바람이 지나가면
환하게 웃을게
봄바람이 지나가면 그때라면
두렵지 않아
서로의 마음을 잘 알아
걱정하지 마 그 누구보다
너를 아끼니까
우리 다시 만나
봄바람이 지나가면
환하게 웃을게 웃을게
봄바람이 지나가면 다 지나가면
우리 다시 만나
봄바람이 지나가면
봄바람이 지나가면
한 번 더 안아줄게 안아줄게
봄바람이 지나가면
그때라면'),
(10,'미소짓던 그 표정이
시도 때도 없던 입맞춤이
주고받던 연락들이
아쉬움 가득한 헤어짐이
없어서 쌓여서
너의 모든 게
더는 남아있질 않아
어쩔 수 없는 걸 알면서도
놓을 수 없는 걸 아쉬움에
더는 너를 불러봐도
어떤 감정도 느껴지질 않아
그저 남아 있을 뿐인걸
차가워진 그 표정이
시도 때도 없는 다툼들이
주고받던 상처들이
가끔은 미안한 마음들이
긴 시간 쌓여서
너의 모든 게
더는 남아있질 않아
어쩔 수 없는 걸 알면서도
놓을 수 없는 걸 아쉬움에
더는 너를 불러봐도
어떤 감정도 느껴지질 않아
그저 남아 있을 뿐인걸
매일 그리던 네 모습도
더는 그려지지 않아
더는 널 원하지 않아
어쩔 수 없는 이 마지막도
놓을 수 없는 네 모습조차
더는 내겐 의미도 없어
미뤄왔던 일처럼 느껴져
이젠 말해야 할 것 같아'),
(11,'맞이하고 보내준 수 많은 일 년 중
그대 내게 떠났던 그 해가 있었죠
어디에 있을까 잘 지내 지나요
아팠던 건 잘 보내 줬나요
날 떠나겠다는 말 참 힘들었어요
사랑한단 말도 그대가 했기에
거기서 떠나요 나도 잘 떠났으니
이제야 그댈 이해하네요
사랑 누구나 하는
흔하디 흔한 이야기
시작의 이유도 헤어짐의 이유도
그땐 모르기에 그저 치열한 날들
우린 어떤 사랑을 했었나요
그 가슴에
가지 말라는 말 왜 안 했겠어요
혹시 싫어할까 가슴에 남긴 말
그대는 그 날로 나를 지워갔겠죠
이제야 그댈 보고 싶은데
사랑 누구나 하는
흔하디 흔한 이야기
숨마저 못 쉬던 걸을 수조차 없던
이별이 기다려 모두 가져간 날들
우린 어떤 이유가 있었나요
떠나던 날
익숙함을 핑계 삼아야 했던
그날이 이제는 그리워질 텐데
말을 못해서 표현 못해서
그댈 단 하루라도
사랑하지 않은 적이 없단 걸
사랑 누구나 하는
흔하디 흔한 이야기
시작의 이유도 헤어짐의 이유도
그땐 모르기에 그저 치열한 날들
우린 어떤 사랑을 했었나요
그 가슴에
사랑 누구나 하는
흔하디 흔한 이야기
숨마저 못 쉬던 걸을 수 조차 없던
이별이 기다려 모두 가져간 날들
우린 어떤 이유가 있었나요
떠나던 날'),#임창정
(12,'I can\'t believe
기다렸던 이런 느낌
나만 듣고 싶은 그녀는 나의 멜로디
하루 종일 go on and on and oh
떠나지 않게 그녈 내 곁에
Don\'t mess up my tempo
들어봐 이건 충분히
I said don\'t mess up my tempo
그녀의 맘을 훔칠 beat
어디에도 없을 리듬에 맞춰 1 2 3
Don\'t mess up my tempo
멈출 수 없는 이끌림
매혹적인 넌 lovely
틈 없이 좁혀진 거리
불규칙해지는 heartbeat
잠시 눈을 감아 trust me
밖으로 나갈 채비 미리 해둬
Are you ready
오늘은 내가 캐리
도시 나 사이의 케미
이미 나와 놓곤 뭐가 창피해 ma boo
어정쩡 어버버 할 필요 없다고
챙길 건 없으니 손잡아 my lady
가는 길마다 레드 카펫
또 런웨이인걸
발걸음이 남달라
지금 이 속도 맞춰보자 tempo
Baby girl 아침을
설레게 하는 모닝콜
매일 봐도 보고 싶은 맘인걸
지금부터 나와 Let\'s get down
모든 것이 완벽하게 좋아
So don\'t slow it up for me
Don\'t mess up my tempo
들어봐 이건 충분히
I said don\'t mess up my tempo
그녀의 맘을 훔칠 beat
어디에도 없을 리듬에 맞춰 1 2 3
Don\'t mess up my tempo
멈출 수 없는 이끌림
주윌 둘러봐 lovely
틈 없이 좁혀진 거리
너에게 맞춰진 heartbeat
하고 싶은 대로 teach me
여긴 내 구역 Don\'t test me
혼자 있기 어색하다면
보내줘 message
Now you got me flexin\'
주윌 둘러봐
널 보는 들러리들 속
위대한 개츠비 Hold on wow
I\'m doing alright baby girl
you don\'t know
치워 네 머리 위에 물음표
내 사전에 없는 LIE
너는 이미 자연스럽게
맞추고 있어 내 tempo
Baby girl 내 어깨에
살짝 기댄 그대의
아련한 향기가 다시 내 맘에
소용돌이치며 몰아친다
이대로 난 영원하고 싶다
So don\'t mess up my tempo baby
Don\'t slow it up for me
Don\'t mess up my tempo
Don\'t mess up my tempo
Don\'t mess up my tempo
Don\'t mess up my tempo
Don\'t mess up my tempo
Don\'t mess up my tempo
Don\'t mess up my tempo
내 눈을 바라보고 말해
나의 귓가에만 닿게
나만 사랑한다 말해
나밖에 없다고 말해
더 이상 흔들리지 않게
절대 널 뺏기지 않게
누구도 건들 수 없게
내 곁에 너를 지킬게
내 마음이 느껴지니
나를 감싸 안은
유일한 나만의 savior
모두 그런 널 바라보게 돼
I can\'t believe
기다렸던 이런 느낌
나만 듣고 싶은 그녀는 나의 멜로디
하루 종일 go on and on and oh
떠나지 않게 그녈 내 곁에
Don\'t mess up my tempo
따라와 이건 충분히
I said don\'t mess up my tempo
완전히 다른 색의 beat
어디에도 없을 이런 완벽한 1 2 3
Don\'t mess up my tempo
멈출 수 없는 이끌림'), #엑소tempo
(13,'네가 없이 웃을 수 있을까
생각만 해도 눈물이나
힘든 시간 날 지켜준 사람
이제는 내가 그댈 지킬 테니
너의 품은 항상 따뜻했어
고단했던 나의 하루에
유일한 휴식처
나는 너 하나로 충분해
긴 말 안 해도 눈빛으로 다 아니깐
한 송이의 꽃이 피고 지는
모든 날 모든 순간 함께해
햇살처럼 빛나고 있었지
나를 보는 네 눈빛은
꿈이라고 해도 좋을 만큼
그 모든 순간은 눈부셨다
불안했던 나의 고된 삶에
한줄기 빛처럼 다가와
날 웃게 해준 너
나는 너 하나로 충분해
긴 말 안 해도 눈빛으로 다 아니깐
한 송이의 꽃이 피고 지는
모든 날 모든 순간 함께해
알 수 없는 미래지만
네 품속에 있는 지금 순간 순간이
영원 했으면 해
갈게 바람이 좋은 날에
햇살 눈부신 어떤 날에 너에게로
처음 내게 왔던 그날처럼
모든 날 모든 순간 함께해'),
(14,'Don\'t walk away I\'m falling down
Don\'t walk away I\'m falling down
깊어져만 가는
밤하늘 별빛은 여전히
그 자리 그대를 기다리죠
한참을 말하지 않아도
그대 두 눈 들여다보면
나는 알아요 그대를 느끼죠
햇살 안은 밤하늘 수평선 멀리
그대의 별 되어 늘 그대를 지킬게요
내 생에 가장 아름다운 시간들
나 그댈 위해 간직해온
짙은 숨결 그대에게
닿기를 바래요
Don\'t walk away I\'m falling down
Don\'t walk away I\'m falling down
점점 멀어지는
한동안 그대 외로이
힘없이 지나간 나날들
나는 아파요 그대를 느끼죠
햇살 안은 밤하늘 수평선 멀리
그대의 별 되어 늘 그대를 지킬게요
내 생에 가장 아름다운 시간들
나 그댈 위해 간직해온
짙은 숨결 전해지길
바래요 오직 나 그대가
내 맘 흐르는 하늘을 바라봐줘요
한걸음 다가와 멀어지진 말아줘요
하루하루 같은 이곳에 남겨져
나 그대에게 머물게요
내 생에 가장 아름다운
그대와 영원히'),
(15,'낮엔 파란 하늘 별이 보이는 밤
기분 좋은 날 오랜만에 모일까
내가 살아가는 삶을 정말 
사랑하지 나는
기분 좋은 날 오랜만에 모일까
Ooh ya ya ya ya yah
Ooh ya ya ya ya yah
Ooh ya ya ya ya yah
기분 좋은 날씨야 오랜만에 모일까
I just wanna chill with my homies
하얀색의 모래 또
파란색의 물 위엔
파도들이 쭉 밀려오지
전화해서 잡아둬 펜션
이미 올라온 텐션 yea
I don\'t care
모아둔 돈을 깨
Lotta cash
얼마든 I\'m okay yea
비싼 옷 빼
입어 cuz 
It\'s a good day
많고 또 많은 스트레스는 어려워
때로는 정답을 몰라 
Sometimes I feel like I\'m at war
Oh no 
but I know it\'s gon be alright
yea
바다로 올라 태워 가자 boat ride
친구들 불러 몽땅
바람 부는 소리
들뜬 맘에 잠을 못자 yea
비싼 옷 빼
입어 cuz
It\'s a good day
Seoul city 서있어 
난 빌딩 옥상에서 봐
어딘가에 가는 사람들 
그 사이에 사이에 
나 줄처럼 얽힌 우리 삶
거기서 도망쳐 나왔어 
기분은 high with 코쿤 또 팔로
Hola pullup hola 우야 
기분 좋은 날씨야 다 모일까 
Indigo cozyboys 우주로 비행
indigo cozyboys 우주로 비행
인생은 trip but 안해 
trip love 난 필요해 들어 내 1집
인생은 trip 인생은 여행 
눈치 왜봐 걔네말 뻔해
인생은 trip 인생은 여행 
어디든지 가자 ok
내위 높지 햇빛 날씬 좋게
Seoul city 먼진 걷게해
Seoul city rollin 
Seoul city finesse
Building 세우지
내 chain bling cling so
여전히 간지부리지 
바람에 내 금 스치지
Geekin geekin will.i.am 
가득 딴 커피 I\'m drippin
여전히 간지불리지 
바람이 체인 스치지
Geekin geekin will.i.am 
언제까지 Till 평생
낮엔 파란 하늘 별이 보이는 밤
기분 좋은 날 오랜만에 모일까
내가 살아가는 삶을 
정말 사랑하지 나는
기분 좋은 날 오랜만에 모일까
Ooh ya ya ya ya yah
Ooh ya ya ya ya yah
Ooh ya ya ya ya yah
기분 좋은 날씨야 오랜만에 모일까
Just another good day 
가지 않아 우울의 늪엔
You see me now 
I\'m beamin like Lupe 
대축제
세련된 감각에 플러스해 
지혜로움과 사랑을 덧셈
Yeah I\'m a sucker for love 
그런데 conscious해 동시에
번 돈을 멋지게 쓰지 
그동안 난 수고했으니
머리부터 발끝 치장하고 
냠냠 배를 채우지
친구들도 바쁘게 살아 
많이 벌어서 다음번에 쏴라
오기 힘들면 가면 되잖아 
화창한 이 날 화는 내지 마
좋은 기분을 나누고파 
사랑하는 사람들과
이런저런 수다 떨면서 
ping and pong 
주고받는 농담
Just another good day 
가지 않아 우울의 늪엔
You see me now 
I\'m beamin like Lupe 대축제
난 원해 더 많은 거 
시간을 담았지
Call ma bro
가지러 가야 돼 손이 난 커
절대로 아냐 그냥 주는 건
여러번 넘어져
But I won\'t 
필요해 지금 난
너 아님 너
걱정마 여기는
Nobody knows
나를 잘 알어 넌 
Nobody knows 
No doubt
이쁜 옷을 골라
I \'ll be at the studio 
I work now
기분좋은 매일이지
Baby with a 검은 머리
나는 느껴 모두를
You can\'t talk now
난 기분이 좋아 
좋은것만 골랐지
챙겨가 나의 기준은 
높아 저멀리
기분따라 생각나서 
전화를 걸었지
기분따라 생각나서 
전화를 ring ring
나는 싫지 않아 이 도시의 빛
밤은 길지 않아 
gotta go to deep
Gotta go to sleep
Baby don\'t you leave me
날아가자 날개 달아 윙윙
날아가자 날개 달아 with me
Just another good day ya ya
Just another good day ya ya
Just another good day ya ya
Just another good day ya ya'),
(16,'멈춘 시간 속
잠든 너를 찾아가
아무리 막아도
결국 너의 곁인 걸
길고 긴 여행을 끝내
이젠 돌아가
너라는 집으로
지금 다시
way back home
아무리 힘껏 닫아도
다시 열린 서랍 같아
하늘로 높이 날린 넌
자꾸 내게 되돌아와
힘들게 삼킨 이별도
다 그대로인 걸
oh oh oh
수없이 떠난 길 위에서
난 너를 발견하고
비우려 했던 맘은 또
이렇게 너로 차올라
발걸음의 끝에
늘 니가 부딪혀
그만
그만
멈춘 시간 속
잠든 너를 찾아가
아무리 막아도
결국 너의 곁인 걸
길고 긴 여행을 끝내
이젠 돌아가
너라는 집으로
지금 다시
way back home
조용히 잠든 방을 열어
기억을 꺼내 들어
부서진 시간 위에서
선명히 너는 떠올라
길 잃은 맘 속에
널 가둔 채 살아
그만
그만
멈춘 시간 속
잠든 너를 찾아가
아무리 막아도
결국 너의 곁인 걸
길고 긴 여행을 끝내
이젠 돌아가
너라는 집으로
지금 다시
way back home
세상을 뒤집어
찾으려 해
오직 너로 완결된
이야기를
모든 걸 잃어도
난 너 하나면 돼
빛이 다 꺼진 여기
나를 안아줘
눈을 감으면
소리 없이 밀려와
이 마음 그 위로
넌 또 한 겹 쌓여가
내겐 그 누구도 아닌
니가 필요해
돌아와 내 곁에
그날까지
I\'m not done'),
(17,'지나간 여름 밤 시원한 가을바람
난 여전히 잠에 들
기가 쉽지않아 뒤척이고 있어
내가 계획했던 것
유난히 뜨거웠던 너
뭐 하나라도 내 걸로 만들기 어려워
또 시간이 들겠지
또 시간이 들겠지
벌써 1년이 벌써 한달이
벌써 하루가
추억할 시간도 없이 빨리
지나갔고 내게는 또
새로운 고민거리들로
단 한시간 조차 못 버티고 있어
마른 입술이 뜯겨
아직도 적응을 못했어 이런 감정은
지나가버리면 그만인데
모르겠어 지나치는 방법을
억지로 감은 눈을 떴을 때
내일 모레였음 좋겠는데
It takes time
지나간 여름 밤 시원한 가을바람
난 여전히 잠에 들
기가 쉽지않아 뒤척이고 있어
내가 계획했던 것
유난히 뜨거웠던 너
뭐 하나라도 내 걸로 만들기 어려워
또 시간이 들겠지
또 시간이 들겠지
It takes time
시간이 들겠지
It takes time
또 시간이 들겠지
It takes time
시간이 들겠지
It takes time
또 시간이 들겠지
언제쯤이면 괜찮아질까
알면서도 자꾸 반복하는 질문
괜찮냐고 들을 때마다
표정은 점점 굳어지는 기분
시간이 들겠지라고 적었다가
지우고 힘들다 라고 써
소원이 있다면
아무 생각 없이 잠들고 싶어
시원한 여름 노래들은
희망고문이였고
오랜만에 갈색의 가을 안에서
나는 기어코
시계만 쳐다보고 있네
얼마나 걸릴 아픔 이길래
이제는 돌아갈 수 없어도
여전히 난 그 자리에 서있어
흩어져 있는 시간 속
우리와 다시 마주칠 순 없을까
많은 시간이 흐른 뒤
그때야 우린 알겠지
내가 계획했던 것
유난히 뜨거웠던 너
뭐 하나라도 내 걸로 만들기 어려워
또 시간이 들겠지
또 시간이 들겠지
It takes time
It takes time
It takes time'),
(18,'인사까진 연습했는데
거기까진 문제없었는데
왜 네 앞에 서면 바보처럼 웃게 돼
평소처럼만 하면 돼
자연스러웠어
머리를 넘기는 척했어
펼친 손이 뻘쭘해서
하정우급 표정 연기
나 너 하나도 안 반가워
취향이 겹치는 척했어
사실 나 그 영화 못 봤어
거울 앞에 멈춰 서서
사랑한다고 얘기했어
인사까진 연습했는데 우
거기까진 문제없었는데
왜 네 앞에 서면 바보처럼 웃게 돼
평소처럼만 하면 돼
자연스러웠어
안녕 안녕
안녕 안녕
안녕 안녕
멋지게 인사하는 법은 아는데
우 너를 보면
우 baby baby
난 이미 다 알고 있어
네 얼굴에 다 쓰여있어
엉성한데 귀여웠어
그 영화 제목도 틀렸어
사실 난 기다리고 있어
사실 꽤 오래 기다렸어
네가 먼저 말해주길
좋아한다고 아님 뭐든
인사까진 연습했는데
거기까진 문제없었는데
네 앞에 서면 바보처럼 웃게 돼
평소처럼만 하면 돼
자연스러웠어
안녕 안녕
안녕 안녕
안녕 안녕
연습해도 안 되는 건 안 되는 거라는
말 안 믿어
인사까진 연습했는데
거기까진 문제없었는데
멋지게 인사하는 법은 아는데
우 너를 보면'),
(19,'아직 이별 중인 나에겐 
끝이 아닌 것만 같아서 
다른 사랑 중인 너지만 
나는 아직 너와 열애 중
나도 너만큼만 헤어지고 싶어
아니 너보다 더 행복하고 싶어
너는 어떻게 날 잊었는지 가르쳐줘
아직 이별 중인 나에게
난 아직 열애 중
누구보다 뜨겁게 사랑해 열애 중
헤어져도 헤어진 적 없어
언젠가 내가 너와 이별할 수 있을까
너만 모르게 나는 아직 너와 열애 중
매일 이별하고 있지만
아직 너를 기다리는 중
나도 너만큼만 못돼지고 싶어
아니 너보다 더 나빠지고 싶어
너는 어떻게 날 잊었는지 가르쳐줘
아직 이별 중인 나에게
난 아직 열애 중
누구보다 뜨겁게 사랑해 열애 중
헤어져도 헤어진 적 없어
언젠가 내가 너와 이별할 수 있을까
아무도 모르게 여기서 널 멈추면
정말 이별이 될까 봐
그게 마지막이 될까 봐
널 후회하는 중
누구보다 너를 많이 원망하는 중
미워해도 미워한 적 없어
언젠가 내가 너를 잊고 살 수 있을까
너만 모르게 나는 아직 너와 열애 중'),
(20,'소란한 내 맘을 누군가 볼까봐
애써 웃는 척 해
사실 나는 누구보다 아픈 중인데
많은 날이 지나면
덤덤하게 잊혀지겠지
다시 또 살아가면서
누군갈 사랑하면서 그렇게
이별하러 가는 길
참 맑기도 하다
널 떼러 가는 길
아무 예고 없이
갑자기 맞이할 이별에
많이 힘들지 몰라 미안해
다신 사랑 안 한단 거짓말
뒤로 우는 널 남긴 채
나 차갑게 떠난다
우리 이제는 안녕 안녕
차라리 나를 미워해
화도 못 내는 네게
너무 쉽게 던진 말
그 말 그게 참 가슴에 남아
미안하단 말 못한 게 후회돼
이별하러 가는 길
참 맑기도 하다
널 떼러 가는 길
아무 예고 없이
갑자기 맞이할 이별에
많이 힘들지 몰라 미안해
다신 사랑 안 한단 거짓말
뒤로 우는 널 남긴 채
나 차갑게 떠난다
우리 이제는 안녕 안녕
다 잊어줘 보란듯이
더 잘 살아가줘
차마 하지 못한 말
붙잡아달란 말
우리 사랑한 그 만큼
그 만큼 아파 미치도록
그리울 사랑아
이게 나란 남자야
못 되고 비겁해
널 울게 만들고
또 니 행복을 빌어
우리 이제는 안녕 안녕 안녕'),
(21,'그래 아무리 애를 써봐도
될 수 없는 건 할 수 없는 건
결국 다 내 탓인 거겠지 뭐
혼자 기도를 해봐도
가질 수 없는 걸 바라고 있는
내 자신이 더 슬퍼 보였어
내가 바라보고 있는 너의
그 예쁜 눈동자엔 내가 이젠 없어서
우리 이제 그만하자
아프지 말라는 말도 잘 자라는 말도
우리 이제 그만하자
사랑한다는 말도 똑바로 못하면서
내가 잘한 것도 없지 뭐
내 기분대로 맘에 없는 말도
참 많이 하곤 했었는데
다 받아줬던 너는
아마 그래서 이젠 나에게
설레지 않는 걸지도 몰라
내가 바라보고 있는 너의 
그 예쁜 눈동자엔 내가 이젠 없어서
우리 이제 그만하자
아프지 말라는 말도 잘 자라는 말도
우리 이제 그만하자
날 사랑한다는 말도 똑바로 못하면서
안돼 가지 마
지금은 아니라고 붙잡아달란 말야
오늘이 지나고 내일이 지나면
우리 이제
오늘이 지나고 내일이 지나면
우리
오늘이 지나고 내일이 지나도'),
(22,'나를 사랑하나요 같은 곳을 보나요
이미 알고 있어요 아닌 걸 알죠
배우지 않았어도 이별은 알 수 있죠
사랑은 늘 더딘데
이별은 서둘러 오네요
너와 사랑했던 이 거리가
나를 눈물짓게 만들어
더 사랑한 사람이
원래 더 아파 노래처럼
다신 누구도 사랑하지마
결국 나만큼 아플테니
그땐 내가 없어 이젠 끝이야 안녕
찬 바람이 불어와 코 끝이 붉어지면
슬픈 노래를 불러
내가 젤 잘하는 거니까
내게 혼자 하는 사랑이란
나를 더 아프게 만들죠
이젠 내게 솔직해져야 해
끝내 난 너에게
슬픈 안녕을 말해야겠어
너를 그 자리에 두고서
나의 사랑 안녕 이젠 그대여 안녕
다시 돌아오지는마
같은 상처를 받기 너무 두려우니까
널 여전히 사랑해
가끔 널 생각해 생각해
우연히 만나면
그냥 모른 척 지나가줄래
나도 널 지운 척 할테니
이미 끝난 사랑 다시 안할래 안녕'),
(23,'빨갛게 물들여 지금 이 시간
I\'ll make it red eh eh eh
Make it red eh eh eh
어느새 내 맘에 빨간 장미처럼
우아하게 eh eh eh
새롭게 eh eh
Rose
이런 느낌은 루비보다 더
루비보다 더
내가 느끼는 반짝임처럼
끌리면 이끌려 Na na now
바로 지금 Na na now
I don\'t wanna make it blue
상상해봐 너의 La Vie en Rose
더 깊어진 눈빛 그 속에 붉어진
내 맘을 타오르게 해 나를 춤추게 해
Ooh 잊지마
여기 서 있는 Rose
Ooh 언제나 빛날 수 있게
La La La La Vie en Rose
Ooh This is my my
La La La La Vie en Rose
Rose
Ooh Oh It\'s my my
La La La La Vie en Rose
기대해도 좋아
왠지 완벽해진 이 느낌
가까이서 봐도 난 좋아
Red
반짝이는 눈빛 루비같이 모든 시선
All eyes on me
내가 그 누구보다도 빛나게
빨갛게 물들일게
이런 느낌은 사탕보다 더
사탕보다 더
내가 느끼는 달콤함처럼
끌리면 이끌려 Na na now
바로 지금 Na na now
I don\'t wanna make it blue
만들어봐 너의 La Vie en Rose
더 깊어진 눈빛 그 속에 붉어진
내 맘을 타오르게 해 나를 춤추게 해
Ooh 잊지마
여기 서 있는 Rose
Ooh 언제나 빛날 수 있게
La La La La Vie en Rose
Ooh This is my my
La La La La Vie en Rose
Rose
Ooh Oh It\'s my my
La La La La Vie en Rose
감았던 눈을 떠봐
달라져 모든 게 다
아무도 모르는 새로운 세상을 봐
Oh baby
La La La La La La La Vie en Rose
전부 다 물들여 Red
La La La La La La La Vie en Rose
꿈이라도 좋아 빨갛게 칠해봐
언제든 깨어날 수 있게
내가 불러 줄게
Ooh 잊지마
여기 서 있는 Rose
Ooh 언제나 빛날 수 있게
La La La La Vie en Rose
Ooh This is my my
La La La La Vie en Rose
Ooh 장밋빛에 물들게
La La La La Vie en Rose
새빨가아아안 My rose
빛이 나아아아 My rose
La La La La Vie en Rose
이 순간 특별하게
We\'ll make it red
Oh it\'s my my
La La La La Vie en Rose'), #23
(24, '내가 말했잖아 속지 말라고
이 손을 잡는 순간
너는 위험해질 거라고
Now you\'re bleeding
근데도 끌리니
뻔히 다 알면서도
왜 그리 빤히 쳐다보니
놔 그냥
조금도 망설이지 말고
놔 그냥
너를 아프게 할 거란 걸
알잖아
네 환상에 아름다운 나는 없어
Can\'t you see that boy
Get away out of my face
더 다가오지 마 boy
슬퍼해도 난 울지 않아
Get away out of my face
더 바라보지 마 boy
슬퍼해도 난 울지 않아
라랄라라라 라랄라라라
라랄라라라 라랄라라라
차가운 나를 보는 너의 눈빛
우릴 비추던 달빛
이제는 저물어 간다고
보이지 않니 날 놓지 못하는 손
조금씩 붉어져가잖아
놔 그냥
조금도 망설이지 말고
놔 그냥
너를 아프게 할 거란 걸
알잖아
네 환상에 아름다운
나는 없어
Can\'t you see that boy
Get away out of my face
더 다가오지 마 boy
슬퍼해도 난 울지 않아
Get away out of my face
더 바라보지 마 boy
슬퍼해도 난 울지 않아
라랄라라라 라랄라라라
라랄라라라 라랄라라라
Can\'t you see that boy
What
Can\'t you see that boy
I ain\'t cry no more
Get away out of my face
더 다가오지 마 boy
슬퍼해도 난 울지 않아
Get away out of my face
더 바라보지 마 boy
슬퍼해도 난 울지 않아
라랄라라라 라랄라라라
라랄라라라 라랄라라라'),
(25,'아련해진 어제 하루가
다시 떠오르는
그대 빛에 가까이 다가오죠
이젠 돌아올 수 없는
소중했던 시간처럼
여전히 내게 머물러
외로움이 길었던 날들
살며시 그대 숨결 불어오죠
한 걸음 다가온 그대란 운명에
애써 감춰두며 꺼내지 못한 말
늘 곁에 있어 줘요
그댄 내게 따스한 어제의
꿈처럼 내린 사랑이죠
허전함이 가득했던 길
그대와 함께라서 행복해요 
한 걸음 다가온 그대란 운명에
애써 감춰두며 꺼내지 못한 말
늘 곁에 있어줘요
그댄 내게 따스한 어제의
꿈처럼 내린 사랑이죠
이젠 숨길 수 없는 내 맘을
나를 가득 채워준 사랑을
그대 드릴게요
한걸음 다가온
그대란 운명에
하나뿐인 사랑 그댈 사랑해요
눈을 감아도 네가 보이는걸
늘 곁에 있어 줘요
그댄 나의 꿈같은 어제와
오늘 그리고 내 전부죠
지울 수 없는 그대이죠'),
(26,'생각보다 더 빨리 너를 잊게 됐어
나 밥 같은 거 안 굶고 살아
네가 줬던 수많은 추억 그중에서
나 좋았던 것만 안고 살아
넌 어떻게 지내니
가끔은 궁금해져
새벽잠이 많지 않던 너
넌 어떻게 지내니
가끔은 묻고 싶어
밥은 먹었니
첫눈은 봤니
생각보다 더 빨리 너를 잊게 됐어
나 주말에는 영화관도 가
네가 줬던 수많은 추억 그중에서
나 울 것 같은 건 참고 살아
넌 어떻게 지내니
조금은 알고 싶어
기침 소릴 달고 살던 너
넌 어떻게 지내니
조금은 묻고 싶어
잠은 잘 잤니
이젠 괜찮니
생각보다 더 빨리 너를 잊게 됐어
나 같이 걷던 곳 혼자도 가
내가 줬던 수많은 기억 그중에서
너 웃던 얼굴만 믿고 살아'),
(27,'쟤네 회사 스튜디오 크기가 
JUSTHIS 개인 스튜디오
영혼 팔았네 JUSTHIS도
좆까는 소리 마
Swings형이 말한 것처럼
This is Hyperreal
쩔어야 할 수 있는 
Type of deal
오디션 안 보고 
오디션으로만
가질 수 있는 걸 
갖고 있는 이 
삶이 멋없다 지랄 말고 
걍 말해 내가 싫다
이건 시작이고 난 
다 깰 거야 국힙 정치판
난 적어도
딴 래퍼들이 술자리에서만 하는 말
음악에서 보여줬지
이제 결과를 봤으니까 
다 좆까라
난 Rihanna Eminem이랑 
Friends될 거야 Monster
난 항상 본 모습 
넌 빨아 남 똥꼬
난 태어났어 예술가로
야비한 새끼들은 전철 밟지
반면 난 내 좆대로 입지 
yeah I\'m on my worst behavior
Drake 전철 밟지 whoa
스튜디오에 계속 
놀러 올 때마다 여자
Swings형에게 감사해야지 
사드려야 해 돈까
근데 그럼 이 형은 말하지 
승아 넌 채식주의자니까 
딴 거 먹자 like this we one
Indigo 
We just go 
Fuck the ops 
Fuck your noise
We make noise 
사시사철 
어디던 
상관없어
Left side 
Right side 
수지타산 
맞으면
어디던 
We just go 
Here we go 
IndiGO
IndiGO
아무도 못 가둬 
난 믿어 anarchyism
회사 말 안 듣는 
십새끼지
다른 래펀 내 밑에 
깔린 굽 cuz
니 커리언 송판 
난 불도저 bitch
작업실 출근은 
아침에 bitch
또 퇴근 때 보는 
하늘은 잿빛
그 말이 무슨 말이냐면 
내 하루는 너네 
아마추어들의 이틀 
분량인 느낌
저번 달 500 
이젠 daydate 살 겨
옷장난 
그다음 단계에 있어
fuck these rap game 
어찌 되던 상관없어 
top level 야매로도
올른 여긴 딱 
그 정도뿐
난 내가 만든 판에 
올라탔어
고등래퍼 솔까 
걔네 노래 좋은데
걔네 노래 안에 마딘 
누구 출처
아마도 
어 아마도 
내가 내 입으론 
말을 못 꺼내겠어 
여기서 question 
힙합 label 들에 
2018 spotlight 
어디 쬐여
Indigo 
We just go 
Fuck the ops 
Fuck your noise
We make noise 
사시사철 
어디던 
상관없어
Indigo 
We just go 
Fuck the ops 
Fuck your noise
We make noise 
사시사철 
어디던 
상관없어
Left side 
Right side 
수지타산 
맞으면
어디던 
We just go 
Here we go 
IndiGO 
IndiGO
보고 배워 신삥 
내 랩이 
지워줄게 비비
너네한테 랩 미끼 
It\'s the gang bitches 
난 패 삐기
예쁜척하는 래퍼들 땜에 
생겼네 틱이
너네 절대 안 믿지 
우정 버려 다 staff 이지
질리도록 뱉네 근데 
얘네 기미 안 보여 느낌 
안 나는 거랑 다른 거지 
니 delivery 
침이 고이는 게 다지 
니 팬들 copy 인지도 모르고 
손 쳐드니 힘이 도네 남아 
bitch 해줄게 비밀로 
몇 곡 모아낸 앨범은 의미 버려
다 구라 까서 벌어 
착하면 더
병신아 낚아도 보여 
여기 나와봐라 전부
내 flow 잡아 목덜미 
버텨 아파도 벌
너네 낙하로 떨어지고 
다 약발로 뻗지
Indigo 
We just go 
Fuck the ops 
Fuck your noise
We make noise 
사시사철 
어디던 
상관없어
Left side 
Right side 
수지타산 
맞으면
어디던 
We just go 
Here we go 
IndiGO 
IndiGO
도착했어 indigo 
삐뚤어진 시선 fuck it 형 
Business 걍 닥치고 
니 강강 swervin 다 불러서 
앞으로 세운 다음에 
Suwoncityboy 
Metro go boomin 
like a brr ta ta 
닥치고 배운 다음 후에 
씨부렁 거리소 
배워 먹은
버르장 머린기야 
삔또 나가 
래퍼s told me 
같은 레퍼토리 
여기 ep 한 장 
발라드 내고 
방학식 열었지
니가 동경하는 
래퍼들은 
내 가사의 좆집 
다신 박힌 채로 
주인님께 
왈왈 대지 않기
여기 삔또 나가 
래퍼s told me 
같은 레퍼토리 
여기 ep 한 장 
발라드 내고 
방학식 열었지
니가 동경하는 
래퍼들은 
내 가사의 좆집 
박힌 채로
주인님께 
왈왈 대지 않기
Indigo 
I just go 
Indigo 
We just go 
어디로 
몰라도 
We just go 
직진 go
앞으로 
뒤로 
I don\'t know 
Fuck them hoes 
I don\'t know 
I don\'t know 
Indigo 
We just go 
We just go'),
(28,'You can call me artist
You can call me idol
아님 어떤 다른 뭐라 해도
I don\'t care
I\'m proud of it
난 자유롭네
No more irony
나는 항상 나였기에
손가락질 해 
나는 전혀 신경 쓰지 않네
나를 욕하는 
너의 그 이유가 뭐든 간에
I know what I am
I know what I want
I never gon\' change
I never gon\' trade
Trade off
뭘 어쩌고 저쩌고 떠들어대셔
I do what I do 
그니까 넌 너나 잘하셔
You can\'t stop me lovin\' myself
얼쑤 좋다
You can\'t stop me lovin\' myself
지화자 좋다
You can\'t stop me lovin\' myself
OHOHOHOH
OHOHOHOHOHOH
OHOHOHOH
덩기덕 쿵더러러 
얼쑤
OHOHOHOH
OHOHOHOHOHOH
OHOHOHOH
덩기덕 쿵더러러 
얼쑤
Face off 마치 오우삼 ay
Top star with that spotlight ay
때론 슈퍼히어로가 돼
돌려대 너의 Anpanman
24시간이 적지
헷갈림 내겐 사치 
I do my thang
I love myself
I love myself I love my fans
Love my dance and my what
내 속안엔 
몇 십 몇 백명의 내가 있어
오늘 또 다른 날 맞이해
어차피 전부 다 나이기에
고민보다는 걍 달리네
Runnin\' man
Runnin\' man
Runnin\' man
뭘 어쩌고 저쩌고 떠들어대셔
I do what I do 
그니까 넌 너나 잘하셔
You can\'t stop me lovin\' myself
얼쑤 좋다
You can\'t stop me lovin\' myself
지화자 좋다
You can\'t stop me lovin\' myself
OHOHOHOH
OHOHOHOHOHOH
OHOHOHOH
덩기덕 쿵더러러
얼쑤
OHOHOHOH
OHOHOHOHOHOH
OHOHOHOH
덩기덕 쿵더러러
얼쑤
I\'m so fine wherever I go
가끔 멀리 돌아가도
It\'s okay 
I\'m in love with my-my myself
It\'s okay 
난 이 순간 행복해
얼쑤 좋다
You can\'t stop me lovin\' myself
지화자 좋다
You can\'t stop me lovin\' myself
OHOHOHOH
OHOHOHOHOHOH
OHOHOHOH
덩기덕 쿵더러러 
얼쑤
OHOHOHOH
OHOHOHOHOHOH
OHOHOHOH
덩기덕 쿵더러러
얼쑤'),
(29,'goodbye goodbye 이별을 알았다면
그토록 사랑하지 말 걸 그랬나 봐요

(check it out yo)

무덤덤해져 가는 서로의 감정 때문에 상처를 
주는 것조차도 이제 무덤덤한 우리 
이미 사랑은 떠났고 정밖에 남지 않았어 
그냥 그런가 하고 뜨뜻미지근 해졌지
(where you at)
관심은 집착이 되어 버리고
(where you at)
의심은 거의
밥 먹듯이 해 너와 내가 쌓았던 신뢰란 성은 무너지고
넌 이제 이별길을 걸으며 새사람을 찾지 

같이 울기 위해 널 만난 건 아닌데
(눈물이 난다)
상처받기 위해 쌓은 추억이 아닌데
(잊혀져 간다)
너무 쉽게 또 한 사람과 남이 돼
고작 이별하기 위해 널 사랑한 건 아닌데
(익숙해져 간다)


잘 가요 그 험한 이별길을
나를 떠나 부디 꽃길만 걸어요

조심히 가요 외로운 이별길을
가는 길에 나의 모든 기억을 버려요

(check it out)

지나간 기억 속에서 산다는 건
그 얼마나 무기력한 외로움일까
그 기억 속에서조차 잊혀진다는 건
또 어떤 순간보다 잔인한 아픔인가
죽도록 사랑했건만 끝내 나 죽지 않았네
숨을 깊게 들이마셔도 내뱉으면 한숨이 돼 
누구나 하는 이별이니 우리 슬퍼 말아요
난 또 그대 닮은 듯 아닌 사람 찾아갈게요

같이 울기 위해 널 만난 건 아닌데
(눈물이 난다)
상처받기 위해 쌓은 추억이 아닌데
(잊혀져 간다)
너무 쉽게 또 한 사람과 남이 돼
고작 이별하기 위해 널 사랑한 건 아닌데
(익숙해져 간다)

잘 가요 그 험한 이별길을
나를 떠나 부디 꽃길만 걸어요

조심히 가요 외로운 이별길을
가는 길에 나의 모든 기억을 버려요

(check it out)


goodbye goodbye 이별을 알았다면
그토록 사랑하지 말 걸 그랬나 봐요


goodbye goodbye 어차피 떠난다면
어떤 미련도 남지 않게 보란 듯이 살아요

(check it out)


잘 가요 어여쁜 내 사람아
나를 떠나 행복하게만 살아요

(행복하게만 살아요)

조심히 가요 가슴 아픈 사랑아
내 곁에 있을 때처럼 아프지 말아요

(그대 아프지 말아요)

나
나나나나나나 
나나나나나나 
나나나나나

나나나나 
나
나나나나나나 
나나나나나나 
나나나나나

(check it out)'),
(30,'이별을 말하고 넌 괜찮은 거니
여전히 내 하루는 온통 네 생각에
뜬 눈으로 밤을 지새고
난 두려워 시간이 쌓여갈수록
내가 잊혀질까 봐 우리 시간마저
모두 무너질까 봐
나도 모르게 너무 보고 싶어서
네 집 앞을 찾아가
너도 나만큼은 아닐지라도
보고 싶었다고
말해줘 지금 나 너의 집 앞에 있어
우리의 시간을 되돌려줘
아무 일도 없던 것처럼 날 안아줘
끝이라는 게 난 너무나 두려워서
다가가지도 못하고
한참 서성이다 말도 못하고
다시 돌아가는 나
하루가 가고 또 하루가 지나도
갈수록 커져만 가
맘에 없는 거짓말이라도
날 사랑한다고
말해줘 지금 나 너의 집 앞에 있어
우리의 시간을 되돌려줘
아무 일도 없던 것처럼 날 안아줘
끝이라는 게 난 너무나 두려워서
다가가지도 못하고
한참 서성이면 우리 한 번은
단 한 번쯤은 마주치진 않을까
당장이라도 전활 걸어
네 목소리 듣고 싶은데
내가 더 싫어지게 될까 봐
작은 감정마저 그렇게 사라질까 봐
마음이란 게 말처럼 되질 않잖아
보다 조금만 널 사랑했더라면
스치는 바람처럼 스쳐 지나갈 텐데
끝이라는 게 난 너무나 두려워서
다가가지도 못하고
한참 서성이다 혹시 마주치게 된다면
나처럼 아픈 시간 속에 살았기를
오늘도 난 돌아서지만'),
(31,'Yo what
What\'s your problems
Ain\'t no lie 난 알어
종일 틱틱 대는 애인\'s not one
난 늘 원해왔어 pain killers 
die
넌 늘 원해왔어 pain killers 
not one
I don\'t know why
Baby I don\'t know why
Tell me I\'ll be alright
Baby 내게 말해봐
Baby 내게 말해봐
Baby Are we alright 
Baby Are we alright 
Tell me I\'ll be alright
시동을 난 키지 
We go We been
들이 붓지 다 섞어 whippin
신경끄지 우린 직진
그냥 해 난
말은 언제나 쉽지
하나 둘 씩 켜 밤하늘 별빛
난 시간을 잡아 니 곁에 두지
최대한 멀리 가자 우리가 말하던
나아질걸 알아 난 늘 니가 바라던
니가 말하던 
그런일도 참 많았어 
처음 니가 말하던 후회도 있지 
내 뒤에 잔뜩 쌓아뒀어
묻지마 내게 자꾸 나도 잘 몰라
매일 매일 내일 매일 더는 안 놀라
매일 매일 내일
쳐다봐 저 위
Take that 
매일 매일 다른 pain
떠나 지금 더 멀리
지금 바로 떠나자고 with me
Pay back
Save me
멀어진 이들아 just be with me
더는 미련이 없어
맞다 믿었던 것들도 nothin
내딛어 발
How do u want like this
Comin home 
What u mean
Down wit me
Go wit me
배불리 먹이지
지켜 team
What u need
MKITRAIN
Another league
Eating meat
Go wit me
Go wit me
더 멀리 
더 멀리 
Go with me
더 멀리 
Go with me
Go with me
Go with me
What\'s your problems
짐을 싸 떠나자 
인천공항에서 작별인사
잠시 안녕
문제는 많아 
열 부터 백 더 더 
쌓여가다보면 thousands
짐을 싸 떠나자 
고속터미널서 작별인사
잠시 안녕
What\'s your problems
생각에 잠겨있지 
머리속에 조이스틱
아는 게 많아질수록 
시간이 더 걸리지
누군가의 적대심 
무거워진 어깨짐
너무 많이 겪었으니 
내 표정은 변했지
계약서를 다 읽고 
직원들과 일 얘기
녹음실은 안식처 
복잡하지 인생이
너무 많은 것을 
보고 사는 것은 아닌지
너무 많은 것을 
듣고 살다 보니 쌓였지
Yeah 훌 털어 yeah 
다시 우뚝 서서
Yeah 내 두 발로 걸어 
go 쭉쭉 뻗어
Pray 자기 전에 기도해 
일어나서 이겨내
누구나 힘들어해 
우린 도움이 필요해
삶은 바빠져 yeah 
미랜 낙관적이야
맛을 봐야겠어 
그니까 제발 닥쳐줘 yeah
걔넨 틀렸어 
그래서 선을 그어둬 yeah
짐을 싸 떠나자 작별인사
What\'s your problems
짐을 싸 떠나자 
인천공항에서 작별인사
잠시 안녕
문제는 많아 
열 부터 백 더 더 
쌓여가다보면 thousands
짐을 싸 떠나자 
고속터미널서 작별인사
잠시 안녕
What\'s your problems
묻지마 나 어디로 떠나는지
이제 나 승리는 관심없지
원해 난 맞아 더 큰 돈 and uh
내 동생들에게 받는 존경 
내 가족 다
지켜냈지 난 다음을 봐
갇혔어 너같이 우리 좀만 쉬어
여긴 전부 지쳤어
하나에 이끌려 가다 물론
You talk to me
Babe calllin\' me
Everything with me
You talk to me
Babe calllin\' me
Everything with me
What\'s your problems
짐을 싸 떠나자 
인천공항에서 작별인사
잠시 안녕
문제는 많아 
열 부터 백 더 더 
쌓여가다보면 thousands
짐을 싸 떠나자 
고속터미널서 작별인사
잠시 안녕
What\'s your problems
절대 놓지마 내 손
절대 놓지마 내 손
난 필요했어 매번
Save me Save me save me
절대 놓지마 내 손
절대 놓지마 내 손
쉽지않겠지 매번
Save me Save me save me'),
(32,'착한 얼굴에 그렇지 못한 태도
가녀린 몸매 속
가려진 volume은 두 배로
거침없이 직진
굳이 보진 않지 눈치
Black 하면 Pink
우린 예쁘장한 Savage
원할 땐 대놓고 뺏지
넌 뭘 해도 칼로 물 베기
두 손엔 가득한 fat check
궁금하면 해봐 fact check
눈 높인 꼭대기
물 만난 물고기
좀 독해 난 Toxic
You 혹해 I\'m Foxy
두 번 생각해
흔한 남들처럼 착한 척은 못 하니까
착각하지 마
쉽게 웃어주는 건 날 위한 거야
아직은 잘 모르겠지
굳이 원하면 test me
넌 불 보듯이 뻔해
만만한 걸 원했다면
Oh wait til\' I do what I do
Hit you with that
ddu-du ddu-du du
Hit you with that
ddu-du ddu-du du
지금 내가 걸어가는 거린
BLACKPINK 4 way 사거리
동서남북 사방으로 run it
너네 버킷리스트
싹 다 I bought it
널 당기는 것도 멀리 밀치는 것도
제멋대로 하는 bad girl
좋건 싫어하건 누가 뭐라 하던
When the bass drop
it\'s another banger
두 번 생각해
흔한 남들처럼 착한 척은 못 하니까
착각하지 마
쉽게 웃어주는 건 날 위한 거야
아직은 잘 모르겠지
굳이 원하면 test me
넌 불 보듯이 뻔해
만만한 걸 원했다면
Oh wait til\' I do what I do
Hit you with that ddu-du ddu-du du
Hit you with that ddu-du ddu-du du
What you gonna do
when I come come through
with that that uh uh huh
What you gonna do
when I come come through
with that that uh uh huh
뜨거워 뜨거워 뜨거워 like fire
뜨거워 뜨거워 뜨거워 like fire
뜨거워 뜨거워 뜨거워 like fire
뜨거워 뜨거워 뜨거워 like fire
Hit you with that ddu-du ddu-du du'),
(33,'어색하게 Hi hello
오늘 뭐 했는지 물어봐
깜깜한 밤에 같이 걸으며
좀 떠들다가
내 손 잡아달래
추워 안아달래
I don\'t know anymore
I don\'t know
고민하게 되네 나 혼자서만
이 생각 할까
가끔 힌트인지
나를 갖고 노는 건지
둘 중에 뭘까
나도 잘 모르네
애를 쓰고 있네
Cuz of you
I wanna know just tell me
좋아하는 거 맞지
나는 어떡해
돌아버릴 것 같아
정신 차려야 하지
나는 어떡해
오늘도 네 왔다 갔다
하는 마음이 답답해
어디로 가야 하는지
진심으로 궁금해
짜증 나면서도
네 얼굴만 봐도
내 거라는 걸 충분히 느껴
원한다면 날 사랑한다면
Baby 그냥 Tell me it\'s okay
낮에는 이랬다 밤에는 저랬다
깰 수 없는 너라는 게임
그때도 나를 좋아했다 했잖아
새벽에 연락한 거는 또 뭐야
Here we go again
Back to the start
Oh what should I do
I wanna know just tell me
좋아하는 거 맞지 나는 어떡해
돌아버릴 것 같아
정신 차려야 하지 나는 어떡해
I wanna know just tell me
좋아하는 거 맞지 나는 어떡해
돌아버릴 것 같아
정신 차려야 하지 나는 어떡해
확실해질 때까지 환심을 사든가
홧김에 질러보고 확실히 차이든가
시뮬레이션 그쯤 했음
직접 나서야지
자꾸 뭉뚱그리는데
뾰족한 수가 나올 리가
저 친구는 이미 신호 보낸듯해
내 생각엔
이야기는 전보다
빠르게 전개돼야 해
부담 안 주는 선에서
Go straight
작사해봐서 알겠지만 진심은 통해
Love is not an easy thing
아마 넌 표현이 서투른 마음치
It\'s okay
능숙하면 고백도 그냥 개수작 같아
하트 그려봤잖아
굴곡을 두 번은 거쳐야 돼
Uh 고통스러워도
그런 식의 쓰라림은 기분 좋아
Don\'t miss this chance
빨리 가봐 잘 되면 한턱 쏴
I wanna know just tell me
좋아하는 거 맞니
나는 어떡해
돌아버릴 것 같아
정신 차려야 하지
나는 어떡해
I wanna know just tell me
좋아하는 거 맞지
나는 어떡해
돌아버릴 것 같아
정신 차려야 하지
나는 어떡해'),
(34,'Ima rap till i die, 영원히
그거 하나뿐 나의 소원은
어느날 내가 죽는다면
전설로 남을까 난 여기

되고파 저 하늘의 별이
상처투성이던 내 story
이제는 맑기를 원해
내 뜻이 너에게 닿기를 원해

the rap legend

ayy, s u p e r b e e w h y
s u p e r b e e w h y
우린 우성인자, 가짜들의 무덤위야
shout out to C Jamm, 기다려 johnny\'s rhyme

열 두마디 bars안에 내 flow는 tsunami야
나 여전히 saucin\' 어린 멋진 부자지 young
내 다이아는 frozen, 니껀 녹아 분하지 넌
ayy, 노란머리 양아치, 영원하게 내려 비

quamo team, 우리 재산을 합침
대부업을 하겠지 빚없이 모여 빛이
재벌집 딸 폰에 ring해도 rich bee
직진 go risky, psp같이

I got this game, 손아귀에 있지
Quamo Gang Gang, 사임 사임 sweepin\'
니 여자 지문은 DM DM, 우린 읽씹
우승안해도 내 prob은 아니지
여기서 진 건 재도전뿐이니
흉이 져도 아름다워

burn it
난 이미 레전더리, 아이코닉
죽음 rocksta라고 난 영원해
또 그때서야 오네 내 인정은
왜 이 시대는 저열해?

yo yo yo yo
오늘 내가 죽음 공휴일이요 yo yo yo
yeah i said, yo yo yo yo
오늘 내가 져도 나는 이겨 yo yo yo

hol\' up, we\'ll make u dance
우리 어제도 미래
수퍼비와 our zone
영원히 비 내려

억부터 조
모든 영들은 내 빛 돼
억부터 조
모든 영들은 내 빛 돼

수퍼비와 Zone에
수퍼비와 Zone에
수퍼비와 Zone에
you can\'t enter my zone

수퍼비와 Zone에
수퍼비와 Zone에
수퍼비와 Zone에
you can\'t enter my zone

음 수퍼비와이가 수퍼비와이가
수퍼비와 주거니 받거니한 나의 열 두마디 bars
궁금하지 나의 친 부모님과 류성민한테 받은
too many rhymes

82 거리 안의 우두머리가 돈과 명예
두 마리 다 잡은 유명인사이기 전에
우리는 하나님의 피부를 가진
자랑스런 대한의 기둥 이 땅 가운데
국민이다 임마 

아직도 따라가는 저기 핫바지 와는
많이 달라 구분이 아니고 구별이라는걸
나를 본 넌 주검이야

Original Gimchi 우리 지폐는 won
Means 이미 이김 이지
우리 이름이 길이 길이 이 길 위
새겨 지리

이건 천국에서 내린 노래
이건 승리와 나의 삶의 romance
내 영혼에 박아져 있는 romans
16:19 나의 팀과 외치는 광야의 고백

너의 시대를 지배할 준비가 되어가는 내 작품
살아있는 신화가 되어지는 우리들이야
너가 보는것은 DEJAVU

hol\' up, we\'ll make u dance
우리 어제도 미래
수퍼비와 our zone
영원히 비 내려

억부터 조
모든 영들은 내 빛 돼 (shine!)
억부터 조
모든 영들은 내 빛 돼 (shine!)

수퍼비와 Zone에
수퍼비와 Zone에
수퍼비와 Zone에
you can\'t enter my zone

수퍼비와 Zone에
수퍼비와 Zone에
수퍼비와 Zone에
you can\'t enter my zone

burn it!
난 이미 레전더리, 아이코닉
죽음 rockstar라고 난 영원해
또 그때서야 오네, 내 인정에
왜 이 시대는 저열해?

노래
이건 승리와 나의 삶의 romance
내 영혼에 박아져있는 romans
16:19 나의 팀과 외치는 고백

hol\' up, we\'ll make u dance
우리 어제도 미래
수퍼비와 our zone
영원히 비 내려

억부터 조
모든 영들은 내 빛 돼
억부터 조
모든 영들은 내 빛 돼

수퍼비와 Zone에
수퍼비와 Zone에
수퍼비와 Zone에
you can\'t enter my zone

수퍼비와 Zone에
수퍼비와 Zone에
수퍼비와 Zone에
you can\'t enter my zone에'),

(35,'Mama just killed a man 
Put a gun against his head 
pulled my trigger now he\'s dead 
Mama life had just begun 
But now I\'ve gone and 
thrown it all away 
Mama ooo 
didn\'t mean to make you cry 
If I\'m not back again 
this time tomorrow 
Carry on carry on 
as if nothing really matters 
Too late 
my time has come 
Sends shivers down my spine 
body\'s aching all the time 
Goodbye everybody I\'ve got to go 
Gotta leave you all behind 
and face the truth 
Mama oooh 
I don\'t want to die 
I sometimes wish I\'d never been 
born at all 
I see a little silhouetto of a man 
Scaramouche scaramouche 
will you do the Fandango 
Thunderbolt and lightning 
very very frightening me 
Galileo Galileo 
Galileo Galileo 
Galileo figaro Magnifico 
But I\'m just a poor boy 
nobody loves me 
He\'s just a poor boy 
from a poor family 
Spare him his life 
from this monstrosity
Easy come easy go 
will you let me go 
Bismillah No 
We will not let you go 
Let him go 
Bismillah We will not let you go 
Let him go 
Bismillah We will not let you go 
Let me go 
Will not let you go 
Let me go 
Will not let you go 
Let me go 
No no no no no no no 
Oh Mama mia mama mia 
Mama mia let me go 
Beelzebub 
has a devil put aside for me 
for me 
for me 
So you think you can stone me 
and spit in my eye 
So you think you can love me 
and leave me to die 
Oh baby 
Can\'t do this to me baby 
Just gotta get out 
just gotta get right outta here 
Oh yeah oh yeah 
Nothing really matters 
anyone can see 
Nothing really matters
Nothing really matters to me 
Any way the wind blows'),

(36,'습관처럼 떠오르던
눈에 아른거리던 네 모습이
더는 그려지지 않아
거짓뿐이었던 너의 말과
너도 모르는 너의 모습들을
더는 원치 않아
단 한 번뿐인 이별에도 말하지 못한
너의 진심을 이젠 다 알 것 같은데
미안해 더는 널 바라보지 않아
미안해 더는 나 후회하지 않아
다시 널 마주할 그 순간에도
널 사랑하지 않아 말할 수 있어
수화기 너머 들리는
지친 날 위로하던 네 목소리
더는 그려지지 않아
함께 쌓았던 추억과
그 많던 말들이 아쉬워서
전하지 못한 말들이
미안해 더는 널 바라보지 않아
미안해 더는 나 후회하지 않아
다시 널 마주할 그 순간에도
널 사랑하지 않아 말할 수 있어
어색하게 만난 우리 시작도
처음 고백했던 그 순간들도
다 어제 같은 일인데
누굴 만나 사랑한다는 게
너를 만나 내가 변해간단 게
이젠 없어
미안해 더는 널 사랑하지 않아
미안해 더는 나 후회하지 않아
힘든 시간들에 지쳐갈 때도
이렇게 해야만 내가 편할 것 같아'),
(37,'너희 옷이 그게 뭐야 얼른 갈아입어
구찌 루이 휠라 슈프림 섞은 바보
너희 아보키같아 답이 없다고
나랑 같이 쇼핑 가자 용돈 갖고 와
여름엔 덥게 겨울엔 춥게
여름엔 덥게 겨울엔 춥게
F.L.E.X 질투와 시샘
받으면서 우리 멋있어지자
내 욕을 하는 전국 adidas 점장
매장에 나타나서 모든 옷이 공짜
hash swan처럼 살 빼고 여자 size
핫핑크 입고 블랙핑크 back dancer
minimalist plus military 감성
탈영병 ㄴ 정신병이 함정
말조심해 너 그러다가 까여
욕먹으면 그냥 노창처럼 사라져
they say fashion is a statement ey
Victoria\'s Secret told me
I made it ey
커피숍 알바생 차 딜러가 온다
둘 다 내게 말하지 스윙스 차 골라
JM 김모씨 못 듣는 말은 기모찌
한 놈 구치소 토낄 준비 중인 기리
나머지 살 또 찌면 망할 거야 
Gym Tipi
이제 내 새로운 꼬붕 패션충 킫밀리
너희 옷이 그게 뭐야 얼른 갈아입어
구찌 루이 휠라 슈프림 섞은 바보
너희 아보키같아 답이 없다고
나랑 같이 쇼핑 가자 용돈 갖고 와
여름엔 덥게 겨울엔 춥게
여름엔 덥게 겨울엔 춥게
F.L.E.X 질투와 시샘
받으면서 우리 멋있어지자
white gold vvs
긴팔을 입어 해가 쨍쨍 이어도
얼음 넣어 카페인에
얼음 박은 손 때문에 감기에 걸려도
i be flexin in 딴 나라 6월부터 쭉
they call me
딴따라 앞 성공한 붙여서
shooting shooting
근데 데이트할 땐 자제해줘
shooting shooting
길거리에 내 노래 booming
이번 여름은
더 뜨겁네 작년보다 내게
돈을 써도 돈이 벌려 계속
텐진에서 도쿄 오사카 다시 텐진
대체 몇 번 탄 거냐고 비행기
귀엔 에어팟
on it playing silkybois
매일 사랑하는 너도 같이
인터넷 볼 시간 없지
이번 여름
summer gonna be alright
내 옆으로 와서 앉아 난
고삐 안 풀린 boy from the 00
니 안전 따위 안 보장
걍 두 눈 똑바로 뜬 채로
아이 코 베여도
솔까놓고 싫지 않아
1고고고고 no stop
지난여름에도 이어서 난 식지 않아
날 위로 올렸던 소리 무슨 소리
aint a 연결고리 몇 천의 구두소리
밖엔 비가 주륵 내리고
올해는우리꺼 다시 떼
7에 반을 주고 땡겨 악셀레이터
자기야 내게 6개월만을 줘
전국구를 돌아 10억이 니 마니또
겨울에 크리스마스는 더운 섬에서
걱정하지 마 어차피
이 안엔 너만 있어
그냥 뭐 퉁 쳤어 7단위 0과
두세 번의 여름을
그딴 건 필요도 없어
다시 돌아오는 해엔
다른 오빠일지도 mm
그냥 뭐 퉁 칠 수가 없어
이 사계절이 돌아도
난 못되겠지 어른
그냥 너도 그때쯤에 가서 옆자리에
남아주는 것만으로 감사를
너희 옷이 그게 뭐야 얼른 갈아입어
구찌 루이 휠라 슈프림 섞은 바보
너희 아보키같아 답이 없다고
나랑 같이 쇼핑 가자 용돈 갖고 와
여름엔 덥게 겨울엔 춥게
여름엔 덥게 겨울엔 춥게
F.L.E.X 질투와 시샘
받으면서 우리 멋있어지자'),
(38,'어떠니 잘 지냈니 지난 여름
유난히도 힘에 겹더라 올핸
새벽녘엔 제법 쌀쌀한 바람이 어느덧
니가 좋아하던 그 가을이 와
사랑도 그러게 별수없나 봐
언제 그랬냐는 듯 계절처럼 변해가
그리워져 미치도록 사랑한 그날들이
내 잃어버린 날들이
참 많이 웃고 울었던 그때
그 시절의 우리
니가 떠올라 밤새
참 아프다 니가 너무 아프다
너를 닮은 이 시린 가을이 오면
보고 싶어서 너를 안고 싶어서
가슴이 너를 앓는다
어떠니 넌 괜찮니 지금쯤은
나를 잊고 편안해졌니 이젠
우습지 잘살길 바라면서도
막상 날 잊었을 널 떠올리면 서글퍼
그리워져 미치도록 사랑한 그날들이
내 잃어버린 날들이
참 많이 웃고 울었던 그때
그 시절의 우리
니가 떠올라 밤새
참 아프다 니가 너무 아프다
너를 닮은 이 시린 가을이 오면
보고 싶어서 너를 안고 싶어서
가슴이 너를 앓는다
너라는 계절 안에 살아
여전히 너를 꿈꾸며
고마워져 그 날들이
내 지나버린 날들이
추억은 짐이 아니라
살게 하는 힘이란 걸
가르쳐준 너니까
또 설렌다 아프도록 설렌다
너를 닮은 눈부신 가을이 오면
니가 떠올라 그리움이 차올라
눈물로 너를 앓는다
밤새 또 너를 앓는다'),

(39,'이 밤 그날의 반딧불을
당신의 창 가까이 보낼게요
음 사랑한다는 말이에요
나 우리의 첫 입맞춤을 떠올려
그럼 언제든 눈을 감고
음 가장 먼 곳으로 가요
난 파도가 머물던
모래 위에 적힌 글씨처럼
그대가 멀리 사라져 버릴 것 같아
늘 그리워 그리워
여기 내 마음속에
모든 말을 다 꺼내어 줄 순 없지만
사랑한다는 말이에요
어떻게 나에게
그대란 행운이 온 걸까
지금 우리 함께 있다면 아
얼마나 좋을까요
난 파도가 머물던
모래 위에 적힌 글씨처럼
그대가 멀리 사라져 버릴 것 같아
또 그리워 더 그리워
나의 일기장 안에
모든 말을 다 꺼내어 줄 순 없지만
사랑한다는 말
이 밤 그날의 반딧불을 당신의
창 가까이 띄울게요
음 좋은 꿈 이길 바라요'),

(40,'그 예쁜 아이가
날 미워하기 시작했다
한 번도 본 적 없는 눈으로
날 바라본다
지레짐작도 안 될 만큼
난 잘못이 많다
언제쯤에 난 변할까
아침이 되면 밤이
부끄럽다 말을 한다
우리의 계절이
참 지겹다고 말을 한다
난 모르는 척 괜히 떼쓰고
기껏 말을 돌려놔도
소용없을걸
그대의 숨결 남방 신발
가방 기침 알약
어질른 방과 꽃과
젖은 옷과 누런 장판
다 좋아요
다 좋아요
그대가 책갈피 대신 쓰던
내가 준 편지
난 별론데
당신은 펑펑 울던 영화까지
다 좋아요
다 좋아요
몇 권의 시집처럼
너는 나를 읽고 만다
당신의 손끝이
날 넘기고 얘긴 끝났다
초라한 나는
두를 띠지도 없이 못났다
언제쯤에 난 변할까
거봐요 아닌 거잖아요
나를 새기다 말고 어디 가요
당신의 방 한구석에다
몰래 적은 몇 글자
혼자 발견하고 킬킬대곤
몇 번 문대 지워지겠죠
그대의 숨결 남방 신발
가방 기침 알약
어질른 방과 꽃과
젖은 옷과 누런 장판
다 좋아요
다 좋아요
그대가 책갈피 대신 쓰던
내가 준 편지
난 별론데
당신은 펑펑 울던 영화까지
다 좋아요
다 좋아요
그 예쁜 아이가
날 미워하기 시작했다
한 번도 본 적 없는 눈으로
날 바라본다
지레짐작도 안 될 만큼
난 잘못이 많다
지레짐작도 안 될 만큼
난 잘못이 많다
아침이 되면
밤이 부끄럽다 말을 한다
아침이 되면
밤이 부끄럽다 말을 한다
아침이 되면
밤이 부끄럽다 말을 한다
아침이 되면 밤이 부끄럽다'),

(41,'라라라라라라라 라라라라라라라
You and me in the moonlight
별 꽃 축제 열린 밤
파도 소리를 틀고 춤을 추는 이 순간
이 느낌 정말 딱야
바다야 우리와 같이 놀아
바람아 너도 이쪽으로 와
달빛 조명 아래서 너와 나와 세상과
다 같이 Party all night long yeah
it\'s good
If you wanna have some fun
짭짤한 공기처럼 이 순간의 특별한
행복을 놓치지마
One two three let\'s go
저 우주 위로 날아갈 듯 춤추러 가
Hey Let\'s dance the night away
Let\'s dance the night away
One two three let\'s go
저 바다 건너 들릴 듯 소리 질러
let\'s dance the night away
Dance the night away
Let\'s dance the night away
Dance the night away
Let\'s dance the night away
You and me in this cool night
미소 짓는 반쪽 달
그 언젠가 너와 나 저 달 뒷면으로 가
파티를 열기로 약속
yeah it\'s good
If you wanna have some fun
은빛 모래알처럼 이 순간의 특별한
행복을 놓치지 마
One two three let\'s go
저 우주 위로 날아갈 듯 춤추러 가
Hey Let\'s dance the night away
Let\'s dance the night away
One two three let\'s go
저 바다 건너 들릴 듯 소리 질러
let\'s dance the night away
오늘이 마지막인 듯
소리 질러 저 멀리
끝없이 날아오를 듯
힘껏 뛰어 더 높이
오늘이 마지막인 듯
소리 질러 저 멀리
쏟아지는 별빛과
Let\'s dance the night away
Let\'s dance the night away
One two three let\'s go
저 바다 건너 들릴 듯 소리 질러
let\'s dance the night away
Let\'s dance the night away
Dance the night away
Dance the night away
Dance the night away
Let\'s dance the night away'),

(42,'비가 내리다 말다
우산을 챙길까 말까
tv엔 맑음이라던데
네 마음도 헷갈리나봐
비가 또 내리다 말다
하늘도 우울한가봐
비가 그치고나면
이번엔 내가 울것만같아
Strumming down to my memories
지직거리는 라디오에선
또 뻔한 love song
잊고있던 아픈 설레임
널 생각나게해
우리 걷던 이길위에
흘러나오던 멜로디 
흥얼거렸었지 넌 어디있니
하늘은 이렇게 맑은데
비에 젖은 내 마음을
따뜻하게도 비춰주던 너는
나에게 햇살같아
그런널 왜 난 보냈을까
Good bye
So hard to lose but easy to repeat
푹 숙인 얼굴 날 알아봤을까
I\'m losing my breathe
잊고 싶던 아픈 기억들
날 더 힘들게해
시간가는 줄도 모르고
나눴던 수많은 밤과 사랑노래
꿈보다 달콤했지
쉽게 포기한건아닌지
우연히널 마주친 순간
내 마음 들킬까봐 뒤돌아섰어
널 잡았다면
그런 널 왜 난 보냈을까 
우리 걷던 이길위에
흘러나오던 멜로디 
흥얼거렸었지 넌 어디있니
하늘은 이렇게 맑은데
비에 젖은 내 마음을
따뜻하게도 비춰주던 너는
나에게 햇살같아
그런널 왜 난 보냈을까
Good bye'),

(43,'매일 같은 옷을 입는 이유 
너와 함께 입던 옷이라서
혹시 어디선가 알아보고 
날 찾아줄까 봐
네가 좋아했던 옷을 입고 
네가 좋아했던 가수처럼
노래하면 네가 볼 것 같아서
신용재를 따라 하고 
따라 해도 안 되는 것처럼
사랑을 따라 하고 
흉내 내도 안 되는 것처럼
목이 부서져라 
이 노래를 불러도
너는 다시 돌아오질 않잖아
네가 그렇게도 좋아했었던 
그 노래처럼
그때 네가 나를 떠난 이후 
쉬지 않고 연습하는 이유
혹시 어디선가 들린다면 
너 돌아볼까 봐
이제 우리 얘기가 돼버린
네가 좋아했던 노래들을
불러보면 네가 울 것 같아서
신용재를 따라 하고 
따라 해도 안 되는 것처럼
사랑을 따라 하고 
흉내 내도 안 되는 것처럼
목이 부서져라 
이 노래를 불러도
너는 다시 돌아오질 않잖아
그때 그 노래처럼
아직 내가 너를 못 버리는 이유
여태 바보처럼 기다리는 이유
아직 내겐 사랑이라서
아무리 미친 듯이 불러봐도 
넌 안 들리나 봐
이별은 연습하고 연습해도 
안 되는 건가 봐
목이 부서져라 다시 너를 불러도
너는 내게 돌아오질 않잖아
네가 그렇게도 좋아했었던 
그 노래처럼'),

(44,'Yeah woo uh woo uh
nananana dadadada
영원히 날 사랑한다
그리 말하던 너야
내게 말했던 너야
그 말이 날 맴도는데
너를 어떻게 놓아 놓아 널 baby
아닌 걸 알지만 끝인 걸 알지만
자꾸만 난 아직도 널 아직
떠나려고 해도 꼭 같은 힘으로
난 널 붙잡고 있어
네 미래라 내게 그러더니
과거가 되었니
오직 나만 사랑한다더니
네 마음은 영원히
내 곁에만 머문다 그러더니
내 전부를 걸었어 그랬더니
날 떠나버렸니
아직도 난 널 기다리잖니
내 마음은 여전히
널 끌어당겨 gravity
네 말투 문장 단어들 하나하나
기억 다 하는 나야
그날의 네가 날 맴도는데
너를 어떻게 놓아 놓아 널 baby
Believe란 단어 속 숨겨져 있던 lie
그걸 못 봐 아직도 난 아직
너의 거짓말이 또 거짓일 거라고
날 속이고 있어
네 미래라 내게 그러더니
과거가 되었니
오직 나만 사랑한다더니
네 마음은 영원히
내 곁에만 머문다 그러더니
내 전부를 걸었어 그랬더니
날 떠나버렸니
아직도 난 널 기다리잖니
내 마음은 여전히
널 끌어당겨 gravity
내가 걸었던 너란 배팅은 결국 fail
혼자서 독주하던 raise
Honey look at me now
또 대답 없는 메아리만
돌아와 계속 맴돌기만 해
망가져가는 나를 또 뒤로한 채
네가 없는 이 우주를 떠돌까 두려워
널 위한다면 뭐든 움직일 힘이 있어
잘 알잖아
근데 네 마음만큼은 내 맘대로 안돼
아직 나를 끌어당기는
너의 무게는 계속 날 집어삼켜
갈수록 더 늘어가는 상처
이젠 추억도 자취를 감춰
머릿속에 번진
너의 모습들은 거짓
대체 뭘 믿어야 되는 건지
확신이 안 서 다시 또
너의 뒷모습에 소리쳐 맴돌고 있어
네 미래라 내게 그러더니
과거가 되었니
오직 나만 사랑한다더니
네 마음은 영원히
내 곁에만 머문다 그러더니
내 전부를 걸었어 그랬더니
날 떠나버렸니
아직도 난 널 기다리잖니
내 마음을 알잖니
난 널 믿었어 그랬더니'),

(45,'시간이 멈춘 것처럼
내게는 기적 같은 일이야
우연히 걸었던 이 길에서
널 처음 봤던 순간
겁이 많은 나는 너에게
기대고 싶었어
이제 와 돌이켜 보면
우린 결코 우연은 아니었어
이유도 없이 나의 편이 되어줬던 너
차가워진 나의 손을 꼭 잡아주던 널
안아주고 싶어
이제는 나보다 소중한 You
곁에만 두고 싶어
내가 있어야 할 곳은 You
시간이 지나도 항상 여기에 있을게
언제라도 네가 쉴 수 있는
집이 되어줄게
You
늘 돌아올 수 있게
You
언제나
Ay 보이지 않던 모든 게
내 눈에 보이네
이 순간의 내 마음에 Eh Eh
다 정해져 있던 것처럼
서로에게 더 더 이끌렸어 어쩌면
우리가 만나기 전부터
한때는 당연하게 받기만 했어
늘 나의 마음을 말로만 전하지 못한
수많은 날 이기적이었던 날
곁에서 아무 말 없이
얼마나 힘들었을까
이유도 없이 나의 편이 되어줬던 너
차가워진 나의 손을 꼭 잡아주던 널
안아주고 싶어
이제는 나보다 소중한 You
곁에만 두고 싶어
내가 있어야 할 곳은 You
시간이 지나도 항상 여기에 있을게
언제라도 네가 쉴 수 있는
집이 되어줄게
가장 편한 그 마음으로
꿈을 품을 수 있도록
네 마음의
짐을 다 덜 수 있도록
네겐 없던 이유들도 내게는 생겼어
어두웠던 내 모든 걸
안아준 너 때문에 Uh
Because of you
나 아닌 너 때문에 Uh
All about you
이젠 낯선 날들이
두렵지 않게 해줄게
너와 내 마음의 편안한 집이 돼 줄게
안아주고 싶어
이제는 나보다 소중한 You
곁에만 두고 싶어
내가 있어야 할 곳은 You
시간이 지나도 항상 여기에 있을게
언제라도 네가 쉴 수 있는
집이 되어줄게
You
늘 돌아올 수 있게
You
언제나'),

(46,'눈 감으면 더욱 선명해지는 게
어떤 말로도 설명이 안 됐어
유리 위를 혼자서 걸어가
그댈 혹시나 아프게 할까
내가 여기 있는데
나를 몰라보나요
너무 보고 싶어
한참 기다렸는데
손이 닿지 않네요
그냥 멍하니 서 있네요
안녕 안녕 안녕 goodbye
꿈인듯해 자꾸만 같은 일들이
나를 조금씩 무너지게 만해
잠시나마 나를 기억해주던 순간
기적 같았어 전부 꿈만 같아
내가 여기 있는데
나를 몰라보나요
너무 보고 싶어
한참 기다렸는데
손이 닿지 않네요
그냥 멍하니 서 있네요
안녕 안녕 안녕 goodbye
시간이 지나도 변치 않는
나만 아는 그대의 진한 그 향기가
날 알아보나요 나를 찾았나요
하얗게 또 밤이 번져가요
그댈 아프게 한 날이 지나고 또다시
안녕 안녕 안녕 goodbye
안녕 안녕 안녕 goodbye'),

(47,'난 지금 네게 가고 있는 길이야
봄의 끝보다 훨씬 빠르게
할 말이 있는 걸 말하지 않으면
평생을 후회하며 살 것 같아
아마도 살 것 같아 너랑 숨 쉬면
정신 못 차리겠어 눈이 감기고
I just want you to know
I\'m the real one
that you\'re looking for
걱정은 불안함 안에 가둬
건너편에 다 놔두고
이제부터 우리 사진 주워 담아
네 손아귀 안에
아기자기 걸어 둘 거야
어디든지 보이게 해줘
나 없인 안 된다 해줘
너 없인 안 된다 난 너여야 한다
아무리 생각해도 난 결국 너야
후회하긴 싫다 너를 사랑한다
Cuz u r the only one
나는 너뿐이라는 걸
Hah ah ah ah ah ah ah
Let\'s get it on let\'s get it on
Hah ah ah ah ah ah
Why don\'t you be my girl
Hah ah ah ah ah ah ah
Let\'s get it on let\'s get it on
Cuz u r the only one for me
아직도 네게 가고 있는 길이야
여름밤 공기보다 뜨겁게
그리워했던 널 붙잡지 못하면
평생을 후회하며 살 것 같아
네가 너무 보고 싶어서
Yeah yeah yeah
Girl I swear this ain\'t
no booty call nah nah nah
그냥 생각나서
하는 것도 아니야 Nope
드디어 정신 차렸어
너 없인 안 된다는 걸
Now I know now I know
다시 시작해 볼
생각 있으면 처음처럼
만날 생각이 있으면 Lemme know
Let\'s give it a go
너 없인 안 된다 난 너여야 한다
아무리 생각해도 난 결국 너야
후회하긴 싫다 너를 사랑한다
Cuz u r the only one for me
나의 여름 널 어떻게 하겠니
해를 몇 번을 넘겨도 You and me
너를 사랑해 사랑해
또 말하고 말해도
오직 너여야만 I can live
우리 뜨겁게 잡은 손 꽉 잡아 더
여름밤의 Love 꽉 안아 더
두근두근 우린 구름 구름 위
이대로 우리 둘 2
너 없인 안 된다 난 너여야 한다
아무리 생각해도 난 결국 너야
후회하긴 싫다 너를 사랑한다
Cuz u r the only one
나는 너뿐이라는 걸
Hah ah ah ah ah ah ah
Let\'s get it on let\'s get it on
Hah ah ah ah ah ah
Why don\'t you be my girl
Hah ah ah ah ah ah ah
Let\'s get it on let\'s get it on
Cuz u r the only one for me'),

(48,'My life is incomplete
It\'s Missing you
오늘도 하루를 보내 다를 게 없이
하나도 안 어색해 혼자 있는 게
너 없인 안될 것 같던 내가 이렇게 살아
근데 좀 허전해 난 여전히 거기 있나 봐
후련하게 다 털어내 다 다
지난 일에 마음 쓰는 게 
It\'s alright
답이 잘 보이는가 싶다가도
어느새 날 가두는 감옥이 돼
시간은 앞으로만 가는 걸 어째
그 동안 난 아무것도 이룬 것이 없네
아직도 내 마음속엔 너 Oh oh
너를 그리워하다 하루가 다 지났어
너를 그리워하다 일 년이 가버렸어
난 그냥 그렇게 살아
너를 그리워하다 그리워하다
다 괜찮을 거라 되뇌어 봐도
내 하루에 끝엔 또 너로 남아
너 없인 안될 것 같던 내가 이렇게 살아
사실 좀 허전해 넌 여전히 여기 있나 봐
내 마음은 여전해 아직 너를 원해
몇 년이 지나도 난 아직 널 그리워해
난 아직 기억해 우리 처음 봤을 때
네 옷차림과 머리 스타일도 
다 정확하게
I pray for you every night and day
I hope that someday soon 
I can see you once again
아직도 내 마음속엔 너 Oh oh
너를 그리워하다 하루가 다 지났어
너를 그리워하다 일 년이 가버렸어
난 그냥 그렇게 살아
너를 그리워하다 그리워하다
잠에서 깨어 헝클어진 머리처럼 
내 일상도
꽤나 엉망이 돼버렸어 책임져
아무렇지 않은 척 
드리워진 표정도 내 모든 곳에
스며든 네 흔적도 다 책임져 아직도 난
잊을 수 없나 봐 다시 돌아와 줘
또다시 같은 엔딩이라 해도 너
너를 그리워하다 하루가 다 지났어
너를 그리워하다 일 년이 가버렸어
너를 잊으려 하다 하루가 지나가도
너를 지우려 하다 일 년이 가버려도
난 그냥 그렇게 살아
너를 그리워하다 그리워하다
그리워하다 그리워하다'),

(49,'We from gutta 겁나 벌어
그녀처럼 사랑스러워
다섯 살 때부터 버는 법 배웠어
아니 날 때부터 너를 원해 왔어
We from gutta 겁나 벌어
그녀처럼 사랑스러워
다섯 살 때부터 버는 법 배웠어
아니 날 때부터 너를 원해왔어
Broke boi got a job ay
Broke boi got a guap ay
안될 거라고 pipe up ay
화초처럼 다 닥쳐 ay
본 적이 없지 난 면접
본 적이 없지 난 적성
Coo ain\'t play with lame
New wave from dex
im ma go do that shit
ATMbiton rich
질투만 받겠지 but
i dont give a f about that shit
꼰대 새끼들 시비 걸어
걍 직접 전화를 걸어
Coogie는 new school leader
Coogie는 New school leader
No
넌 모를 걸
저 촌스런 래퍼들은
걍 싹 다 넣어둘래
You never know 넌 모를 걸
나 진짜 한국힙합 날 놓치면 반성해
We from gutta 겁나 벌어
그녀처럼 사랑스러워
다섯 살 때부터 버는 법 배웠어
아니 날 때부터 너를 원해 왔어
We from gutta 겁나 벌어
그녀처럼 사랑스러워
다섯 살 때부터 버는 법 배웠어
아니 날 때부터 너를 원해왔어
quamo hooncho
내 목엔 사임 1000 뭉치야
옥타곤 클럽남 스윙스처럼
내 다이아는 춤춰
chyeah i just fucked yo bitch
with my shinin bust down dick
huh 돈 많은 한국남 만렙 졸부
전에는 버카 찍 chyeah
maserati 같은 거 타고
pull up on yo block
쌍라를 키지
animal\'s flow
나는 다치면 동물병원에 가
cuz i\'m a beast
maserati 같은 거 타고
pull up on yo block
쌍라를 키지
animal\'s flow
나는 다치면 동물병원에 가
cuz i\'m a beast
gucci louis fendi 바구니에 dunk
백화점의 슈팅가드 i ball
팀원들 것까지 바구니에 dunk
2018년 난 kevin durant
oh man oh man
방금 전만 해도 그지였네
oh man oh man
이젠 사임사임 1000장을 세
We from gutta 겁나 벌어
그녀처럼 사랑스러워
다섯 살 때부터 버는 법 배웠어
아니 날 때부터 너를 원해 왔어
We from gutta 겁나 벌어
그녀처럼 사랑스러워
다섯 살 때부터 버는 법 배웠어
아니 날 때부터 너를 원해왔어
We gutta young flow
다른 래퍼들관 난 거릴 두지 난
I don\'t give a what about a
내 기분은 after 두시 반
I wanna recognize face
I wanna recognize face
다른 래퍼들 나 땜에
I don\'t give emm
chinese rap what up 칭챙총
땀나게 쥐어 손엔 microphone
뒤돌아 본 다음 뒤담화도 불가능해
man take dat vibe
feeling so high
기분 so fly
기분은 좋은데
괜시리 느껴지는 병신 래퍼들 땜에
Lookin Lookin Switch
cookin cookin sushi
Pull it Pull it bang bang
Cuz I\'m modelin
trendsetter trendsetter trendsetter trend
백 프로 백 프로 백 프로 백
beach I\'m young flex go zone
딴 래퍼들은 집으로 Gone
We from gutta 겁나 벌어
그녀처럼 사랑스러워
다섯 살 때부터 버는 법 배웠어
아니 날 때부터 너를 원해 왔어
We from gutta 겁나 벌어
그녀처럼 사랑스러워
다섯 살 때부터 버는 법 배웠어
아니 날 때부터 너를 원해왔어'),

(50,'언제부터인지 습관처럼 연락하고
마주한 시간이 더는 설레질 않아
하루 종일 반복되는 다툼까지도
사소하게 쌓인 오해마저
어떤 말로 풀어야 하는지
익숙한 탓인지 조금은 지겹기도 해
혼자인 시간이 가끔은 그립기도 해
하루 종일 궁금하던 너의 안부도
더는 쉽게 물어볼 수 없는
그런 감정에 하루를 살아
넌 어떻게 지내는 건지
혹시 나와 같은 지 바쁜 일상 속에
내 생각 같은 건 하지 않는지
날 만나 사랑했던 걸
후회하진 않는지 끝이라는 게
생각보다 쉬운 일인 건 아닌지
쉬울 줄 알았어 널 마주하기 전에는
마음과는 달랐어
왜 이렇게 아픈 건지
생각보다 너무 쉽게
잊혀질 걸 알면서
왜 함께한 날들이 떠오르는지
넌 어떻게 지내는 건지
혹시 나와 같은 지 바쁜 일상 속에
내 생각 같은 건 하지 않는지
날 만나 사랑했던 걸
후회하진 않는지 끝이라는 게
생각보다 쉬운 일인 건 아닌지
사실 잠시뿐인 걸 알고는 있지만
어떤 말로
우리를 끝내 보내야 하는지
널 다시 만날 수 있을까
함께 나눈 그 많은 말들과 온기가
거짓말처럼 지워질까
어떤 말도 할 수 없는
마지막을 건네는 너의 표정이
돌아선 지금도 지워지지를 않아
그때의 너는 어떤 마음이었을까'),

(51,'널 위해서라면 난 
슬퍼도 기쁜 척 할 수가 있었어 
널 위해서라면 난 
아파도 강한 척 할 수가 있었어 
사랑이 사랑만으로 완벽하길 
내 모든 약점들은 다 숨겨지길 
이뤄지지 않는 꿈속에서 
피울 수 없는 꽃을 키웠어 
I\'m so sick of this 
Fake Love Fake Love Fake Love 
I\'m so sorry but it\'s 
Fake Love Fake Love Fake Love 
I wanna be a good man just for you 
세상을 줬네 just for you 
전부 바꿨어 just for you 
Now I dunno me who are you 
우리만의 숲 너는 없었어 
내가 왔던 route 잊어버렸어 
나도 내가 누구였는지도 
잘 모르게 됐어 
거울에다 지껄여봐 너는 대체 누구니 
널 위해서라면 난 
슬퍼도 기쁜 척 할 수가 있었어 
널 위해서라면 난 
아파도 강한 척 할 수가 있었어 
사랑이 사랑만으로 완벽하길 
내 모든 약점들은 다 숨겨지길 
이뤄지지 않는 꿈속에서 
피울 수 없는 꽃을 키웠어 
Love you so bad Love you so bad 
널 위해 예쁜 거짓을 빚어내 
Love it\'s so mad
Love it\'s so mad
날 지워 너의 인형이 되려 해
Love you so bad
Love you so bad
널 위해 예쁜 거짓을 빚어내
Love it\'s so mad
Love it\'s so mad
날 지워 너의 인형이 되려 해
I\'m so sick of this
Fake Love Fake Love Fake Love
I\'m so sorry but it\'s
Fake Love Fake Love Fake Love
Why you sad I don\'t know 난 몰라
웃어봐 사랑해 말해봐
나를 봐 나조차도 버린 나
너조차 이해할 수 없는 나
낯설다 하네
니가 좋아하던 나로 변한 내가
아니라 하네
예전에 니가 잘 알고 있던 내가
아니긴 뭐가 아냐 난 눈 멀었어
사랑은 뭐가 사랑
It\'s all fake love
Woo I dunno I dunno I dunno why
Woo 나도 날 나도 날 모르겠어
Woo I just know I just know
I just know why
Cuz it\'s all Fake Love
Fake Love Fake Love
Love you so bad Love you so bad
널 위해 예쁜 거짓을 빚어내
Love it\'s so mad
Love it\'s so mad
날 지워 너의 인형이 되려 해
Love you so bad Love you so bad
널 위해 예쁜 거짓을 빚어내
Love it\'s so mad
Love it\'s so mad
날 지워 너의 인형이 되려 해
I\'m so sick of this
Fake Love Fake Love Fake Love
I\'m so sorry but it\'s
Fake Love Fake Love Fake Love
널 위해서라면 난
슬퍼도 기쁜 척 할 수가 있었어
널 위해서라면 난
아파도 강한 척 할 수가 있었어
사랑이 사랑만으로 완벽하길
내 모든 약점들은 다 숨겨지길
이뤄지지 않는 꿈속에서
피울 수 없는 꽃을 키웠어'); #fakelove 51


