<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
h2 {
padding-top: 1.5%;
text-align: center;
}
table {
	width: 80%;
	position: absolute; left: 50%; top: 58%;

transform: translate(-50%, -50%);

text-align: center;
}
</style>
<%@ include file="../include/header.jsp"%>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    function daumZipCode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                    document.getElementById("address1").value = extraAddr;
                } else {
                    document.getElementById("address2").value = '';
                }
                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('zipcode').value = data.zonecode;
                document.getElementById("address1").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("address2").focus();
            }
        }).open();
    }
    
$(function(){
	$("#btnUpdate").click(function(){
		document.form1.action="${path}/member/update.do";
		document.form1.submit();
	});
	$("#btnDelete").click(function(){
		if(confirm("삭제하시겠습니까?")){
			document.form1.action="${path}/member/delete.do";
			document.form1.submit();
		}
	});
});    
</script>
</head>
<body>
	<%@ include file="../include/menu.jsp"%>
	<h2>회원정보 상세페이지</h2>
	<form name="form1" method="post">
		<table>
			<tr>
				<td><label class="input-group-text" id="basic-addon1">이름</label></td>
				<td><input class="form-control" name="name" value="${dto.name}"></td>
			</tr>
			<tr>
				<td><label class="input-group-text" id="basic-addon1">아이디</label></td>
				<td><input class="form-control" name="userid" value="${dto.userid}" readonly>
				</td>
			</tr>
			<tr>
				<td><label class="input-group-text" id="basic-addon1">비밀번호</label></td>
				<td><input class="form-control" type="password" name="passwd"></td>
			</tr>
			<tr>
				<td><label class="input-group-text" id="basic-addon1">이메일</label></td>
				<td><input class="form-control" name="email" value="${dto.email}"></td>
			</tr>
			<tr>
				<td><label class="input-group-text" id="basic-addon1">우편번호</label></td>
				<td><input class="form-control" name="zipcode" id="zipcode" value="${dto.zipcode}" readonly>
				<input  class="form-control" type="text" onclick="daumZipCode()" value="우편번호 찾기">
				</td>
			</tr>
			<tr>
				<td><label class="input-group-text" id="basic-addon1">주소</label></td>
				<td><input class="form-control" name="address1" id="address1"
					value="${dto.address1}"></td>
			</tr>
			<tr>
				<td><label class="input-group-text" id="basic-addon1">상세주소</label></td>
				<td><input class="form-control" name="address2" id="address2"
					value="${dto.address2}"></td>
			</tr>
			<tr>
				<td><label class="input-group-text" id="basic-addon1">가입일자</label></td>
				<td><fmt:formatDate value="${join_date}"
						pattern="yyyy-MM-dd HH:mm:ss" /></td>
			</tr>
			<tr>
				<td colspan="2" align="center"><input class="btn btn-outline-dark flex-shrink-0" type="button" value="수정"
					id="btnUpdate"> <input class="btn btn-outline-dark flex-shrink-0" type="button" value="삭제"
					id="btnDelete">
					<div style="color: red;">${message}</div></td>
			</tr>
		</table>
	</form>

</body>
</html>
