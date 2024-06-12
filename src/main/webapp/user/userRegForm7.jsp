<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>♧ 회원가입 ♣︎</title>

  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
    integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">

  <style>
    body {
      min-height: 100vh;
  	  
	background-image: url('https://cdn.inflearn.com/public/files/posts/38f50939-dbdc-4b1c-b4f8-72144342026f/%EB%B0%B0%EA%B2%BD.png');
	background-image: no-repeat; /*배경 이미지 반복 안 함 */
	background-size: 100% 100%;
    }

    .input-form {
      max-width: 680px;

      margin-top: 80px;
      padding: 32px;

      background: #fff;
      -webkit-border-radius: 10px;
      -moz-border-radius: 10px;
      border-radius: 10px;
      -webkit-box-shadow: 0 8px 20px 0 rgba(0, 0, 0, 0.15);
      -moz-box-shadow: 0 8px 20px 0 rgba(0, 0, 0, 0.15);
      box-shadow: 0 8px 20px 0 rgba(0, 0, 0, 0.15);
    }
    .btn-primary {
    color : white;
    background-color: orange;
    border-color: orange;
}
  </style>
  
  <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
  
  <script>
	$(document).ready(function(){
		
		$("#uName").focus();
		
		$("#btnReg").on("click",function(){
			
			// 영문 대소문자, 숫자로만 이루어진 4~12자리 정규식
			var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;
			// 이름 정규식
			var nameCheck = /^[가-힣]+$/; 
			// 닉네임 정규식
			var nickCheck =  /^[가-힣a-zA-Z]{2,8}$/;
			// 전화번호 정규식
			var phoneCheck = /^[0-9]{2,3}-[0-9]{3,4}-[0-9]{3,4}$/;
			// 이메일 정규식
			var emailCheck = /^[a-z0-9\.\-_]+@([a-z0-9\-]+\.)+[a-z]{2,6}$/;
			// 생년월일 정규식
			var birthCheck = /^[0-9]{8}$/;
			
			if($.trim($("#uName").val()).length <= 0)
			{
				alert("Oi름을 입력ㅎH주세요.");
				$("#uName").val("");
				$("#uName").focus();
				return;
			}
			
			if(!nameCheck.test($("#uName").val()))
			{
				alert("Oi름은 한글로만 입력ㄱr능합ㄴiㄷr.");
				$("#uName").val("");
				$("#uName").focus();
				return;
			}
			
			if($.trim($("#uNickName").val()).length <= 0)
			{
				alert("별명을 입력ㅎH주세요.");
				$("#uNickName").val("");
				$("uNickName").focus();
				return;
			}
			
			if(!nickCheck.test($("#uNickName").val()))
			{
				alert("별명은 2-8 ㅈrㄹi의 영문, 한글, 숫자로만 입력ㄱr능합ㄴiㄷr.");
				$("#uNickName").val("");
				$("uNickName").focus();
				return;
			}
			
			if($.trim($("#uBirth").val()).length <= 0)
			{
				alert("생년월일을 입력ㅎH주세요.");
				$("#uBirth").val("");
				$("#uBirth").focus();
				return;
			}
			
			if(!birthCheck.test($("#uBirth").val()))
			{
				alert("생년월일 형식Oi 올ㅂr르ㅈi 않습ㄴiㄷr. ㄷrㅅi 입력ㅎH주세요.");
			}
			
			if($.trim($("#uEmail").val()).length <= 0)
			{
				alert("Oi메일을 입력ㅎH주세요.");
				$("#uEmail").val("");
				$("#uEmail").focus();
				return;
			}
			
			if(!emailCheck.test($("#uEmail").val()))
			{
				alert("Oi메일 형식Oi 올ㅂr르ㅈi 않습ㄴiㄷr. ㅈH 입력ㅎH주세요.");
				$("#uEmail").val("");
				$("#uEmail").focus();
				return;
			}
			
			if($.trim($("#uPhone").val()).length <= 0)
			{
				alert("전화번호를 입력ㅎH주세요.");
				$("#uPhone").val("");
				$("#uPhone").focus();
				return;
			}
			
			if(!phoneCheck.test($("#uPhone").val()))
			{
				alert("전화번호 형식Oi 올ㅂr르ㅈi 않습ㄴiㄷr. ㄷrㅅi 입력ㅎH주세요.");
				$("#uPhone").val("");
				$("#uPhone").focus();
				return;
			}
			
			if($.trim($("#uId").val()).length <= 0)
			{
				alert("OrOiㄷi를 입력ㅎH주세요.");
				$("#uId").val("");
				$("#uId").focus();
				return;
			}
			
			if(!idPwCheck.test($("#uId").val()))
			{
				alert("OrOiㄷi는 4-12 자리의 영문, 숫자로만 입력ㄱr능합ㄴiㄷr.");
				$("#uId").val("");
				$("#uId").focus();
				return;
			}
			
			if($.trim($("#uPassword1").val()).length <= 0)
			{
				alert("ㅂi밀번호를 입력ㅎH주세요.");
				$("#uPassword1").val("");
				$("#uPassword1").focus();
				return;
			}
			
			if(!idPwCheck.test($("#uPassword1").val()))
			{
				alert("ㅂi밀번호는 4-12 자리의 영문, 숫자로만 입력ㄱr능합ㄴiㄷr.");
				$("#uPassword1").val("");
				$("#uPassword1").focus();
				return;
			}
			
			if($("#uPassword1").val() != $("#uPassword2").val())
			{
				alert("ㅂi밀번호ㄱr 동일ㅎrㅈi 않습ㄴiㄷr.");
				$("#uPassword2").val("");
				$("#uPassword2").focus();
				return;
			}
			
			$.ajax({
				type:"POST",
				url:"/user/userIdCheckAjax7.jsp",
				data:{
					uId:$("#uId").val()
				},
				datatype:"JSON",
				success:function(obj){
					var data = JSON.parse(obj);
					
					if(data.flag == 0)
					{
						document.getElementById("checkCheck").innerHTML = "<font color=brown>OrOiㄷi  ㅅr용ㄱr능</font>";
						document.bbsForm.submit();
					}
					else if(data.flag == 1)
					{
						document.getElementById("checkCheck").innerHTML = "<font color=brown>중복된 OrOiㄷi 존ㅈH..OTL</font>";
						$("#uId").focus();
					}
					else
					{
						document.getElementById("checkCheck").innerHTML = "<font color=brown>OrOiㄷi를 입력ㅎH주세요..</font>";
						$("#uId").focus();
					}
				},
				error:function(xhr, status, error){
					document.getElementById("checkCheck").innerHTML = "<font color=brown>OrOiㄷi 중복 확인 중 오류ㄱr 발생..OTL</font>";
				}
			});
		});	
	});  
  </script>
</head>

<body>
  <div class="container">
    <div class="input-form-backgroud row">
      <div class="input-form col-md-12 mx-auto">
        <h4 class="mb-3"> 회원ㄱr입 🌰 </h4>
       
        <form class="validation-form" name="bbsForm" method="post" action="/user/userProc7.jsp">

          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="name">Oi름</label>
              <input type="text" class="form-control" id="uName" name="uName" value="" required>
            </div>
            <div class="col-md-6 mb-3">
              <label for="nickname">별명</label>
              <input type="text" class="form-control" id="uNickName" name="uNickname" value="">
              <div class="invalid-feedback">
              </div>
            </div>
          </div>

        <div class="mb-3">
            <label for="uBirth">생년월일</label>
            <input type="text" class="form-control" id="uBirth" name="uBirth" placeholder="20000101">
            <div class="invalid-feedback">
        </div>
            
          <div class="mb-3">
          <br >
            <label for="email">Oi메일</label>
            <input type="email" class="form-control" id="uEmail" name="uEmail" placeholder="you@example.com" >
            <div class="invalid-feedback">
          
            </div>
          </div>
          <div class="mb-3">
            <label for="uPhone">전화번호</label>
            <input type="text" class="form-control" id="uPhone" name="uPhone" placeholder="ㅎrOi픈 (-) 포함 작성" >
            <div class="invalid-feedback">
              
            </div>
          </div>
 
          </div>
          <div class="row">
            <div class="col-md-8 mb-3">
              <label for="root">성별</label>
              <select class="custom-select d-block w-100" id="uGender" name="uGender">
                <option value=""></option>
                <option selected>M</option>
                <option>W</option>
              </select>
              <div class="invalid-feedback">
              </div>
            </div>
          </div>
          
           <div class="row">
            <div class="col-md-6 mb-3">
              <label for="uId">OrOiㄷi</label>
              <input type="text" class="form-control" id="uId" name="uId" required>
              <span id="checkCheck" ></span>
            </div>
           
            </div> 
		
         <div class="mb-3">
         <br />
            <label for="password">ㅂi밀번호</label>
            <input type="password" class="form-control" id="uPassword1" name="uPassword" required>
            <div class="invalid-feedback">
            </div>
          </div>
          
          <div class="mb-3">
            <label for="passwordCheck">ㅂi밀번호 확인</label>
            <input type="password" class="form-control" id="uPassword2" required>
            <div class="invalid-feedback">
          
            </div>
          </div>
            </form>
          
          <hr class="mb-4">
          
          <div class="mb-4"></div>
          <button class="btn btn-primary btn-lg btn-block" id="btnReg" name="btnReg">회원가입</button>
      </div>
    </div>
    <footer class="my-3 text-center text-small">
      <p class="mb-1">&copy; 2021 YD</p>
    </footer>
  </div>



</body>

</html>