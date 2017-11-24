<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%if(session.getAttribute("UserId")==null){
response.sendRedirect(request.getContextPath() + "/index.jsp");
}%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet"
	href="<%=request.getContextPath()%>/css/teacherPage.css">
<link rel="shortcut icon" type="image/x-icon"
	href="<%=request.getContextPath()%>/icon/cms2.ico" media="screen" />

<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery-3.2.1.min.js"></script>

<link type="text/css" rel="stylesheet"
	href="<%=request.getContextPath()%>/layui/css/layui.css">
<script src="<%=request.getContextPath()%>/layui/layui.js "></script>
<title>班级信息</title>



<script type="text/javascript">
//修改班级信息
function changeWhenClick(clazzId) {
	 var clazzIdpre = clazzId.substring(3);
	 document.getElementById("preclazzId").value = clazzIdpre;
	$('#clazzForm').toggle();	
}
function saveChange() {
	 $.ajax({
         type: "GET",
         data: {
        	 "clazzId": $('#preclazzId').val(),
        	 "clazzName": $('#preclazzName').val()
         },
         contentType: "application/json; charset=utf-8",
         dataType: "json",
         async: false,
         url: "<%=request.getContextPath()%>/clazz/changeClazzByAjax.do",
         success: function (data) {
        	 alert(data.message);
        	 window.location.reload();
         },
         error: function (data) {
             alert("修改失败！");
         },
     });
}
//ajax删除clazz,本质上是修改clazz的外键courseId为null
function deleteClazzByAjax(clazzid) {
	var clazzId = clazzid.substring(3);
	 $.ajax({
         type: "GET",
         data: {
        	 "clazzId": clazzId
         },
         contentType: "application/json; charset=utf-8",
         dataType: "json",
         async: false,
         url: "<%=request.getContextPath()%>/clazz/deleteClazzById.do",
         success: function (data) {
        	 alert(data.message);
        	 window.location.reload();
         },
         error: function (data) {
             alert("删除失败！");
         },
     });
}
//隐藏正在滚动刷新的验证码
function closeValidateCode() {
	$("#validateCode").hide();
}
//二维码要用到的随机数
function hello(){ 
	 $.ajax({
         type: "GET",
         data: {
         },
         contentType: "application/json; charset=utf-8",
         dataType: "json",
         async: false,
         url: "<%=request.getContextPath()%>/student/getVertifyCode.do",
         success: function (data) {
        	 $("#validateCode").html(data.code);
        	 var t2 = window.setTimeout("hello()",15000);//15s后刷新随机数
         },
         error: function (data) {
             alert("服务器异常！");
         },
     });
	 window.setTimeout("closeValidateCode()",30000);
	} 
//倒计时
var maxtime = 10;
function CountDown(){  
		if(maxtime>=0){   
			 seconds = maxtime;  
			 msg = "签到码还有<span style='color:red; font-size:1.5em;'>"+seconds+"</span>秒刷新";  
			 document.all["timer"].innerHTML=msg;   
			 --maxtime;  
		}else{  
		clearInterval(timer);    
		}  
}  
//timer = setInterval("CountDown()",1000); 	
//显示签到二维码
function showQrImg() {
	$('#getAllInfo').hide();
	$('#qrHref').attr("disabled","disabled");
	 $.ajax({
         type: "GET",
         data: {
        	 "teacherMobile":${teacher.teacherMobile},
        	 "courseId": ${course.courseId}
         },
         contentType: "application/json; charset=utf-8",
         dataType: "json",
         async: false,
         url: "<%=request.getContextPath()%>/course/getQrImg.do",
         success: function (data) {
        	 var url = "/ClassManageSys/qrImg/" + data.url + ".gif";
        	 var imgPre = document.getElementById("qrImg");
//         	 imgPre.style.display = "block";
             imgPre.src = url;
             setInterval("CountDown()",1000);
             //5s刷新
             setInterval('YesConfirm()', 5000);
             var t1 = window.setTimeout("hello()",10000); //10s后显示随机数
            // window.clearTimeout(t1);//去掉定时器             
         },
         error: function (data) {
             alert("服务器异常！");
         },
     });
}
//获取签到成功学生列表
function YesConfirm() {
	 $.ajax({
         type: "GET",
         data: {
        	 "courseId": ${course.courseId}
         },
         contentType: "application/json; charset=utf-8",
         dataType: "json",
         async: true,
         url: "<%=request.getContextPath()%>/student/getTemStudent.do",
         success: function (data) {
        	    var dataObj = data.clazzStuss, //返回的data为json格式的数据
        	    con =  '\
        	    		<caption>当前签到进度</caption>\
        				<tr>\
        					<th>学号</th>\
        					<th>姓名</th>\
        					<th>班级</th>\
        				</tr>\
        				';
        	    $.each(dataObj, function (index, item) {  
        	        con += "<tr>";
        	        con += "<td>" + item.student.studentRoNo + "</td>";
        	        con += "<td>" + item.student.studentName + "</td>";
        	        con += "<td>" + item.clazz.clazzName + "</td>";
        	        con += "<tr/>";
        	    });
        	        //可以在控制台打印一下看看，这是拼起来的标签和数据
        	        //把内容入到这个div中即完成
        	        $('#showStudents').show();
        	    $("#showStudents").html(con);
         },
         error: function (data) { 
             console.log(data);
             alert("服务器异常！");
         },
     });
}
//提交签到表
function submitSignIn() {
	 $.ajax({
         type: "GET",
         data: {
        	 "courseId": ${course.courseId}
         },
         contentType: "application/json; charset=utf-8",
         dataType: "json",
         async: false,
         url: "<%=request.getContextPath()%>/student/submitSignIn.do",
			success : function(data) {
				alert(data.message);
				window.location.reload();
				$('#getAllInfo').show();
			},
			error : function(data) {
				alert("服务器异常！");
			},
		});
	}
//ajax获取上传的文件列表
function getPrivateData() {
	 $('#signModel').hide();
	 $('#getHeadLine').html("上传文件");
	 $('#otherModel').hide();
	 $('#addExaminationDiv').hide();
	 $('#addClassShow').hide();
	 $('#clazzInfoShow').hide();
	 $('#addQuestionsDiv').hide();
	 $('#inClazzStudentInfoDiv').hide();
	 $('#upLoadShow').show();
	 $.ajax({
         type: "GET",
         data: {
        	 "courseId":${course.courseId}
         },
         contentType: "application/json; charset=utf-8",
         async: false,
         url: "<%=request.getContextPath()%>/teacher/getPrivateData.do",
		success : function(data) {
			var dataObj = data.filePackages;
			 con = "";
			 $.each(dataObj, function (index, item) {
				    con += "<tr>";
        	        con += "<td style='text-align:center;'>" + item.fileType + "</td>";
        	        con += "<td style='text-align:center;'>" + item.createTime + "</td>";
        	        con += "<td style='padding-left:5%;'><a href=\'<%=request.getContextPath() %>/file/"+item.fileName+"\'>" + item.fileName + "</a></td>";
        	        con += "<tr/>";
        	    });
			 $('#privateData').html(con);
		},
		error : function(data) {
		},
		dataType : "json",
	});
}
function timeoutForFileList() {
	setTimeout('getPrivateData()',2000);
}
//添加班级
function getAddClass() {
	 $('#getHeadLine').html("添加班级");
	 $('#signModel').hide();
	 $('#otherModel').hide();
	 $('#upLoadShow').hide();
	 $('#clazzInfoShow').hide();
	 $('#addExaminationDiv').hide();
	 $('#addQuestionsDiv').hide();
	 $('#inClazzStudentInfoDiv').hide();
	 $('#addClassShow').show();
}
//班级信息
function classInfo() {
	 $('#getHeadLine').html("班级信息");
	 $('#signModel').hide();
	 $('#otherModel').hide();
	 $('#upLoadShow').hide();
	 $('#addClassShow').hide();
	 $('#addExaminationDiv').hide();
	 $('#addQuestionsDiv').hide();
	 $('#addClassShow').hide();
	 $('#inClazzStudentInfoDiv').hide();
	 $('#clazzInfoShow').show();
	 
}
//添加班级
function teacherAddClazz() {
	if($('#clazzName').val().length > 0 && $('#clazzName').val().length <21 & $('#currentYear').val()!=""){
		$.ajax({
	         type: "GET",
	         data: {
	        	 "courseId":${course.courseId},
	        	 "clazzName":$('#clazzName').val(),
	        	 "currentYear":$('#currentYear').val()
	         },
	         contentType: "application/json; charset=utf-8",
	         async: false,
	         url: "<%=request.getContextPath()%>/clazz/addClazz.do",
			success : function(data) {
				if(data.result == true){
					$('#afterAddClazz').show();
					setTimeout('yourFunction()',2000);
				}
			},
			error : function(data) {
				alert("??");
			},
			dataType : "json",
		});
	}
}
//刷新当前页面
function yourFunction() {
 window.location.reload();
}
//查看班级里的学生信息
function aClick(clazzId) {
	$.ajax({
        type: "GET",
        data: {
       	 "clazzId":clazzId
        },
        contentType: "application/json; charset=utf-8",
        async: false,
        url: "<%=request.getContextPath()%>/student/selectStudentByClazzId.do",
		success : function(data) {
			$('#clazzInfoShow').hide();
			$('#studentCount').html(data.count);
			$('#getHeadLine').html("班级  " + data.clazzName + "学生信息");
			var dataObj = data.students;
			 con = "";
			 $.each(dataObj, function (index, item) {
				    con += "<tr>";
       	        con += "<td style='text-align:center;'>" + item.studentRoNo + "</td>";
       	        con += "<td style='text-align:center;'>" + item.studentName + "</td>";
       	        con += "<td style='text-align:center;'>" + item.studentGender + "</td>";
       	        con += "<td style='text-align:center;'>" + item.studentMobile + "</td>";
       	        con += "<td style='text-align:center;'><img src=\'/ClassManageSys/studentPhoto/"+item.studentPhoto+"\'/></td>";
       	        con += "<tr/>";
       	    });
			 $('#inClazzStudentInfoTable').html(con);
			 $('#inClazzStudentInfoDiv').show();
		},
		error : function(data) {
			alert("??");
		},
		dataType : "json",
	});
}
//点击添加试卷
function addExamination() {
	 $('#getHeadLine').html("添加试卷");
	 $('#addQuestionsDiv').hide();
	 $('#signModel').hide();
	 $('#otherModel').hide();
	 $('#upLoadShow').hide();
	 $('#clazzInfoShow').hide();
	 $('#inClazzStudentInfoDiv').hide();
	 $('#addClassShow').hide();
	 
	$.ajax({
	        type: "GET",
	        data: {
	        	"courseId":${course.courseId}
	        },
	        contentType: "application/json; charset=utf-8",
	        async: false,
	        url: "<%=request.getContextPath()%>/exam/selectExaminationByCourseId.do",
			success : function(data) {
				var dataObj = data.examinations;
				 con = "";
				 $.each(dataObj, function (index, item) {
					    con += "<tr>";
	       	        con += "<td style='text-align:center;'>" + item.examinationID + "</td>";
	       	        con += "<td style='text-align:center;'>" + item.examinationName + "</td>";
	       	        con += "<td style='text-align:center;'>" + item.onlyCode + "</td>";
	       	        con += "<td style='text-align:center;'>" + item.totalValue + "</td>";
	       	        con += "<td style='text-align:center;'>" + item.startTime + "</td>";
	       	        con += "<td style='text-align:center;'>" + item.duration + "</td>";
	       	        con += "<td style='text-align:center;'>" + item.examinationStatus + "</td>";
	       	        con += "<td style='text-align:center;'><a href=\'#\'>" + "删除" + "</a></td>";
	       	        con += "<td style='text-align:center;'><a href=\'#\'>" + "修改" + "</a></td>";
	       	        con += "<td style='text-align:center;'><a id="+item.examinationID+" onclick='createQuestion(this.id)' href=\'#\'>" + "出题" + "</a></td>";
	       	        con += "<tr/>";
	       	    });
				 $('#examinationShowTable').html(con);
				 $('#addExaminationDiv').show();
			},
			error : function(data) {
				alert("??");
			},
			dataType : "json",
		});
	 $('#addExaminationDiv').show();
}
function FirstFunction() {
	 $('#afterAddExamination').hide();
	 addExamination();
	 window.location.hash = "#title";   
}
//教师添加试卷
function teacherAddExamination() {
	if($('#examinationName').val() != "" && $('#totalValue').val() != "" && 
			$('#startTime').val() != "" && $('#duration').val() != ""){
		$.ajax({
	        type: "GET",
	        data: {
	         "courseId":${course.courseId},
	       	 "examinationName":$('#examinationName').val(),
	       	 "totalValue":$('#totalValue').val(),
	       	 "startTime":$('#startTime').val(),
	         "duration":$('#duration').val()
	        },
	        contentType: "application/json; charset=utf-8",
	        async: false,
	        url: "<%=request.getContextPath()%>/exam/addExamination.do",
			success : function(data) {
				if(data.result == true){
					$('#afterAddExamination').show();
	                setTimeout('FirstFunction()',2000);
				}else {
					$('#afterAddExamination').html("添加失败");
					$('#afterAddExamination').show();
	                setTimeout('FirstFunction()',2000);
				}
			},
			error : function(data) {
				alert("??");
			},
			dataType : "json",
		});
	}
}
//教师出题
function createQuestion(id) {
	$.ajax({
        type: "GET",
        data: {
       	 "examinationId":id
        },
        contentType: "application/json; charset=utf-8",
        async: false,
        url: "<%=request.getContextPath()%>/exam/selectExaminationByMyId.do",
		success : function(data) {
			$('#examinationTitle').html(data.examination.examinationName);
			$('#examinationTotalValue').html("总分：" + data.examination.totalValue);
			$('#examinationTime').html("考试时长：" + data.examination.duration + "分钟");
		},
		error : function(data) {
			alert("??");
		},
		dataType : "json",
	});
	$('#addExaminationDiv').hide();
	//$('#addExaminationForm').hide();
	//$('#ExaminationList').hide();
	$('#addQuestionsDiv').show();
}
</script>
</head>
<body>
	<div class="layui-layout layui-layout-admin">
		<!-- 头部导航 -->
		<div class="layui-header header header-demo">
			<div class="layui-main">
				<a class="CMSlogo" href="/"><span
					style="color: white; font-size: 25px;">CMS</span></a>

				<ul class="layui-nav">
					<li class="layui-nav-item"><a href="">签到Module</a></li>
				</ul>
			</div>
		</div>

		<!-- 左侧垂直导航 -->
		<div class="layui-side layui-bg-black">
			<div class="layui-side-scroll">
				<ul class="layui-nav layui-nav-tree" lay-filter="test">
					<!-- 侧边导航: <ul class="layui-nav layui-nav-tree layui-nav-side"> -->
					<li class="layui-nav-item layui-nav-itemed"><a href="#">班级事务</a>
						<dl class="layui-nav-child">
							<dd>
								<a id="classInfo" onclick="classInfo()" href="#">班级信息</a>
							</dd>
							<dd>
								<a id="addClass" onclick="getAddClass()" href="#">添加班级</a>
							</dd>
							<dd>
								<a id="dataUpload" onclick="getPrivateData()" href="#">课件上传</a>
							</dd>
							<dd>
								<a id="afterClass" onclick="afterClassHomeWork()" href="#">课后作业</a>
							</dd>
							<dd>
								<a id="" href="#">发布公告（待定）</a>
							</dd>
						</dl></li>
					<li class="layui-nav-item layui-nav-itemed"><a
						href="javascript:;">签到系统</a>
						<dl class="layui-nav-child">
							<dd>
								<a id="signShow" href="#">点名签到</a>
							</dd>
							<dd>
								<a id="otherShow" href="#">签到记录</a>
							</dd>
							<!-- <dd>
								<a href="#">待定</a>
							</dd> -->
						</dl></li>
		     	<li class="layui-nav-item"><a
						href="javascript:;">考试系统</a>
						<dl class="layui-nav-child">
							<dd>
								<a onclick="FirstFunction()" id="addExamination" href="#">添加试卷</a>
							</dd>
							<dd>
								<a id="correctExamination" href="#">批改试卷</a>
							</dd>
							<dd>
								<a id="lookatScore" href="#">查看成绩</a>
							</dd>
							<!-- <dd>
								<a href="#">待定</a>
							</dd> -->
						</dl></li>
					<!-- <li class="layui-nav-item"><a href="#">产品</a></li>
					<li class="layui-nav-item"><a href="#">大数据</a></li> -->
				</ul>
			</div>
		</div>


		<!-- 内容 -->
		<div class="layui-body site-demo">

			<br> <br> <br> <br> <br> <span
				style="margin-left: 5%; color: #c2c2c2; font-style: oblique;">${course.courseName}：<span
				id="getHeadLine">考勤签到</span></span>
			<hr class="layui-bg-cyan">

			<!-- 班级信息 -->
			<div class="layui-form sessiontable" id="clazzInfoShow"
				style="display: none;">
				<table class="layui-table" lay-even style="text-align: center;">
					<colgroup>
						<col width="150">
						<col width="200">
						<col width="200">
						<col width="150">
						<col width="150">
					</colgroup>
					<thead>
						<tr>
							<th style="text-align: center;">班级</th>
							<th style="text-align: center;">学年</th>
							<th style="text-align: center;" colspan="3">操作</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${! empty course.clazz }">
								<c:forEach items="${course.clazz}" var="c">
									<tr>
										<td>${c.clazzName}</td>
										<td>${c.currentYear}</td>
										<td>
										<input name="clazzId" style="display: none;"
											value="${c.clazzId}" /> <a class="aSign" id="${c.clazzId}"
													onclick="aClick(this.id)" href="#">查看</a>
										</td>
										<td><a class="aSign" id="zxc${c.clazzId}"
											onclick="changeWhenClick(this.id)" href="#">修改</a></td>
										<td><a class="aSign" id="del${c.clazzId}"
											onclick="deleteClazzByAjax(this.id)" href="#">删除</a></td>
									</tr>
									<br />
								</c:forEach>
							</c:when>
							<c:otherwise>
								<a>(空)</a>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>

				<script>
				layui.use('table', function() {
					var table = layui.table;
				});
			    </script>
			</div>
			
			<!-- 班级内部具体信息 -->
			<div class="site-text site-block" id="inClazzStudentInfoDiv"
				style="display: none;">
				<br/>
				班级人数：<span id="studentCount"></span>
				<table  class="layui-table" lay-even>
						<colgroup>
							<col width="200">
							<col width="120">
							<col width="100">
							<col width="200">
							<col width="210">
						</colgroup>
						<thead>
							<tr>
								<th style="text-align: center;">学号</th>
								<th style="text-align: center;">姓名</th>
								<th style="text-align: center;">性别</th>
								<th style="text-align: center;">手机</th>
								<th style="text-align: center;">照片</th>
							</tr>
						</thead>
						<tbody id="inClazzStudentInfoTable">

						</tbody>
					</table>
				</div>

			<!-- 添加班级 -->
			<div class="site-text site-block" id="addClassShow"
				style="display: none;">
				<!-- 新建班级成功提示信息 -->
				<div id="afterAddClazz"
					style="background-color: #393D49; height: 20%; width: 20%; z-index: 20; position: fixed; text-align: center; margin-left: 10%; display: none;">
					<h3 style="color: white; margin-top: 19%">添加班级成功..</h3>
				</div>
				<form action="" class="layui-form layui-form-pane">
					<div class="layui-form-item">
						<label class="layui-form-label">班级名称</label>
						<div class="layui-input-block">
							<input id="clazzName" type="text" name="clazzName" required
								lay-verify="required|idvalidate"
								onchange="searchIfExistCourse()" placeholder="请输入班级名称"
								autocomplete="off" class="layui-input">
						</div>

					</div>

					<div class="layui-form-item">
						<label class="layui-form-label">当前学年</label>
						<div class="layui-input-inline">
							<input id="currentYear" type="text" name="currentYear" required
								lay-verify="required" placeholder="如'2017'" autocomplete="off"
								class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<div class="layui-input-block">
							<input id="AddCourseButton" class="layui-btn"
								onclick="teacherAddClazz()" lay-submit lay-filter="formDemo"
								type="button" value="点击添加" />
							<button type="reset" class="layui-btn layui-btn-primary">重置</button>
						</div>
					</div>
				</form>

				<script>
				layui.use([ 'form', 'laydate' ], function() {
					var form = layui.form, laydate = layui.laydate;
					laydate.render({
						elem : '#currentYear',
						type : 'year'
					});
					
					form.verify({
						idvalidate:[/(.+){1,20}$/,'班级名称必须是1到20位字符'],
					});
				});
				</script>
			</div>
 
			<!-- 签到content -->
			<div id="signModel"
				style="width: 100%; overflow: hidden; height: 100%;">
				<!-- 签到模块 -->
				<div style="width: 49%; float: right; margin-top: 3%;">
					<!-- 二维码模块 -->
					<div style="width: 98%; height: 20%; text-align: center;">
						<!-- 签到数字 -->
						<div id="validateCode"
							style="width: 98; height: 30px; font-size: 25px; text-align: center;">
							<span id="timer">签到码</span>
						</div>
						<!-- 签到二维码 -->
						<div
							style="padding: 10px; width: auto; text-align: center; margin-top: 10px;">
							<img style="border: solid; border-color: black;" id="qrImg"
								src="">
						</div>
					</div>
					<!-- 签到操作 -->
					<div style="text-align: center;">
						<input type="text" value="${course.courseId}"
							style="display: none;" /> <br /> <a id="qrHref"
							class="layui-btn layui-btn-normal" onclick="showQrImg()" href="#">开始签到</a>
						<a class="layui-btn layui-btn-danger" href="#"
							onclick="submitSignIn()">提交签到</a><br /> <br />
					</div>
				</div>
				<!-- 垂直分界线 -->
				<div
					style="float: right; width: 2%; height: 100%; text-align: center;">
					<hr style="width: 2px; height: 100%; background-color: #c2c2c2;"></hr>
				</div>
				<!-- 签到状况模块 -->
				<div style="width: 46%; text-align: center;">
					<!-- 实时签到表 -->
					<table class="layui-table" width="99%" border="1" id="showStudents"
						style="margin-top: 10%; margin-left: 15px; display: none;">
					</table>
					<table id="getAllInfo" style="width: 99%;margin-left: 3%" class="layui-table">
						<caption>本学期签到汇总</caption>
						<thead>
							<tr>
								<th>学号</th>
								<th>班级</th>
								<th>姓名</th>
								<th>签到</th>
								<th>迟到</th>
								<th>早退</th>
								<th>旷课</th>
								<th>请假</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${! empty clazzStus}">
									<c:forEach items="${clazzStus}" var="c">
										<tr>
											<td>${c.student.studentRoNo}</td>
											<td>${c.clazz.clazzName}</td>
											<td>${c.student.studentName}</td>
											<td>${c.student.studentInfo.signIn}</td>
											<td>${c.student.studentInfo.comeLate}</td>
											<td>${c.student.studentInfo.leaveEarlier}</td>
											<td>${c.student.studentInfo.absenteeism}</td>
											<td>${c.student.studentInfo.askForLeave}</td>
										</tr>
									</c:forEach>
								</c:when>
							</c:choose>
						</tbody>
					</table>
				</div>
			</div>

			<script>
				//签到模块显示
				$('#signShow').click(function() {
					$('#getHeadLine').html("点名签到");
					$('#addClassShow').hide();
					$('#otherModel').hide();
					$('#clazzInfoShow').hide();
					$('#inClazzStudentInfoDiv').hide();
					$('#addQuestionsDiv').hide();
					$('#addExaminationDiv').hide();
					$('#signModel').show();
				});
			</script>

			<!-- 签到记录模块 -->
			<div id="otherModel"
				style="display: none; padding:25px 4%;">
                 <table id="getAllInfo" style="width: 99%;" class="layui-table">
						<thead>
							<tr>
								<th>学号</th>
								<th>班级</th>
								<th>姓名</th>
								<th>签到</th>
								<th>迟到</th>
								<th>早退</th>
								<th>旷课</th>
								<th>请假</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${! empty clazzStus}">
									<c:forEach items="${clazzStus}" var="c">
										<tr>
											<td>${c.student.studentRoNo}</td>
											<td>${c.clazz.clazzName}</td>
											<td>${c.student.studentName}</td>
											<td>${c.student.studentInfo.signIn}</td>
											<td>${c.student.studentInfo.comeLate}</td>
											<td>${c.student.studentInfo.leaveEarlier}</td>
											<td>${c.student.studentInfo.absenteeism}</td>
											<td>${c.student.studentInfo.askForLeave}</td>
										</tr>
									</c:forEach>
								</c:when>
							</c:choose>
						</tbody>
					</table>

			</div>

			<script>
				//其它模块显示
				$('#otherShow').click(function(){
					$('#getHeadLine').html("签到记录");
					$('#upLoadShow').hide();
					$('#addClassShow').hide();
					$('#signModel').hide();
					$('#addExaminationDiv').hide();
					$('#inClazzStudentInfoDiv').hide();
					$('#addQuestionsDiv').hide();
					$('#clazzInfoShow').hide();
					$('#otherModel').show();
				})
			</script>

			
		<!-- 添加试卷 -->
        <div id="addExaminationDiv" class="site-text site-block"
				style="display: none; margin-top: 0;">
				
            	<!-- 添加试卷成功提示信息 -->
				<div id="afterAddExamination"
					style="background-color: #393D49; height: 20%; width: 20%; z-index: 20; position: fixed; text-align: center; margin-left: 10%; display: none;">
					<h3 style="color: white; margin-top: 19%">添加试卷成功..</h3>
				</div>
				
				<!-- 填写表单 -->
				<form action="" class="layui-form layui-form-pane" id="addExaminationForm">
				<div class="layui-form-item">
						<label class="layui-form-label">课程名称</label>
						<div class="layui-input-block">
							<input type="text" value="${course.courseName}"
								class="layui-input" readonly="readonly">
						</div>

					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">试卷名称</label>
						<div class="layui-input-block">
							<input id="examinationName" type="text" name="examinationName" required
								lay-verify="required|idvalidate"
								onchange="searchIfExistExamination()" placeholder="请输入试卷名称"
								autocomplete="off" class="layui-input">
						</div>

					</div>
					
					<div class="layui-form-item">
						<label class="layui-form-label">总分值</label>
						<div class="layui-input-block">
							<input id="totalValue" type="text" name="totalValue" required
								lay-verify="required"
							    placeholder="请输入数字"
								autocomplete="off" class="layui-input">
						</div>

					</div>

					<div class="layui-form-item">
						<label class="layui-form-label">开始时间</label>
						<div class="layui-input-inline">
							<input id="startTime" type="text" name="startTime" required
								lay-verify="required" placeholder="如'2017-01-01 13:30:00'" autocomplete="off"
								class="layui-input">
						</div>
					</div>
					
					<div class="layui-form-item">
						<label class="layui-form-label">考试时长</label>
						<div class="layui-input-inline">
							<input id="duration" type="text" name="duration" required
								lay-verify="required" placeholder="如'120分钟'" autocomplete="off"
								class="layui-input">
						</div>
					</div>
					
					<div class="layui-form-item">
						<div class="layui-input-block">
							<input id="AddExaminationButton" class="layui-btn"
								onclick="teacherAddExamination()" lay-submit lay-filter="formDemo"
								type="button" value="添加试卷" />
							<button type="reset" class="layui-btn layui-btn-primary">重置</button>
						</div>
					</div>
				</form>

				<script>
				layui.use([ 'form', 'laydate' ], function() {
					var form = layui.form, laydate = layui.laydate;
					laydate.render({
						elem : '#startTime',
						type : 'datetime'
					});
					
					form.verify({
						idvalidate:[/(.+){1,20}$/,'试卷名称必须是1到20位字符'],
					});
				});
				</script>
				
				
			<!-- 试卷列表 -->
			<table id="ExaminationList" class="layui-table" lay-even style="text-align: center;">
					<colgroup>
						<col width="90">
						<col width="140">
						<col width="80">
						<col width="80">
						<col width="140">
						<col width="140">
						<col width="80">
						<col width="200">
					</colgroup>
					<thead>
						<tr id="title">
							<th style="text-align: center;">试卷编码</th>
							<th style="text-align: center;">试卷名称</th>
							<th style="text-align: center;">考试码</th>
							<th style="text-align: center;">总分</th>
							<th style="text-align: center;">开始时间</th>
							<th style="text-align: center;">考试时长</th>
							<th style="text-align: center;">状态</th>
							<th style="text-align: center;" colspan="3">操作</th>
						</tr>
					</thead>
					<tbody id="examinationShowTable">
						
					</tbody>
				</table>
				<script>
				layui.use('table', function() {
					var table = layui.table;
				});
			    </script>			   
        </div>	
        
         <!-- 添加试题 -->
			    <div class="site-text site-block" id="addQuestionsDiv" 
			    style="display: none; margin-top: 0;">
				<form action="examinationTitle" class="layui-form layui-form-pane" id="addExaminationForm">
				<!-- 试卷名称 -->
				<h2 id="examinationTitle" style="width: 100%;text-align: center;"></h2>
				<!-- 总分 -->
				<h3 id="examinationTotalValue" style="width: 100%;padding-left: 70%;"></h3>
				<!-- 考试时长 -->
				<h3 id="examinationTime" style="width: 100%;padding-left: 70%;"></h3>
				<!-- 单选 -->
				<div class="layui-form-item">
						<label class="layui-form-label">单选</label>
						<a id="SingleSelectionA" onclick="SingleSelectionA()" href="#" style="margin-left: 5%;">
						<i id="SingleSelectionI" class="layui-icon" style="font-size: 30px; color: #1E9FFF;">&#xe608;</i>
						<i id="SingleSelectionII" class="layui-icon" style="font-size: 30px; color: #1E9FFF; display: none;">&#xe625;</i>
						</a>
				</div>
				
				<!-- 多选 -->
				<div class="layui-form-item">
						<label class="layui-form-label">多选</label>
						<a href="#" style="margin-left: 5%;">
						<i class="layui-icon" style="font-size: 30px; color: #1E9FFF;">&#xe608;</i>
						</a>
				</div>
				
				<!-- 判断 -->
				<div class="layui-form-item">
						<label class="layui-form-label">判断</label>
						<a href="#" style="margin-left: 5%;">
						<i class="layui-icon" style="font-size: 30px; color: #1E9FFF;">&#xe608;</i>
						</a>
				</div>
				
				<!-- 填空 -->
				<div class="layui-form-item">
						<label class="layui-form-label">填空</label>
						<a href="#" style="margin-left: 5%;">
						<i class="layui-icon" style="font-size: 30px; color: #1E9FFF;">&#xe608;</i>
						</a>
				</div>
				
				<!-- 简答 -->
				<div class="layui-form-item">
						<label class="layui-form-label">简答</label>
						<a href="#" style="margin-left: 5%;">
						<i class="layui-icon" style="font-size: 30px; color: #1E9FFF;">&#xe608;</i>
						</a>
				</div>
					
					</form>
			    </div>
			    <script type="text/javascript">
			      function SingleSelectionA() {
					$('#SingleSelectionI').toggle();
					$('#SingleSelectionII').toggle();
				}
			    </script>

			<!-- 上传文件 -->
			<div id="upLoadShow" class="site-text site-block"
				style="display: none; margin-top: 0;">
				<!-- 单个文件上传不能超过50M -->
				<span id="MaxUpload" style="color: red;">单个文件不能超过51200k</span><br />

				<div class="layui-upload">
					<form action="">
						<button type="button"
							class="layui-btn layui-btn-normal layui-btn-danger" id="testList">选择文件</button>
						<div class="layui-upload-list">
							<table class="layui-table">
								<thead>
									<tr>
										<th>文件名</th>
										<th>大小</th>
										<th>状态</th>
										<th>操作</th>
									</tr>
								</thead>
								<tbody id="demoList"></tbody>
							</table>
						</div>
						<button type="button" onclick="timeoutForFileList()"
							class="layui-btn" id="testListAction">开始上传</button>
					</form>
				</div>

				<!-- 个人资料 -->
				<div class="layui-form sessiontable "
					style="width: 100%; margin-left: 0">
					<table class="layui-table" lay-even>
						<colgroup>
							<col width="150">
							<col width="200">
							<col width="340">
						</colgroup>
						<thead>
							<tr>
								<th style="text-align: center;">文件类型</th>
								<th style="text-align: center;">上传时间</th>
								<th style="text-align: center;">文件名称</th>
							</tr>
						</thead>
						<tbody id="privateData">

						</tbody>
					</table>

<script>
	layui.use('table', function() {
	var table = layui.table;
		});
</script>
</div>
								
</div>

			<script>
			var ttem;
			function giveValue(id) {
				var a = $('#fileType').val();
				ttem = a;
				$('#beGiveValue').val(ttem);
			}
            layui.use('upload', function(){
             var $ = layui.jquery
             ,upload = layui.upload;
             //设置上传文件单个大小
               //设定文件大小限制

             //文件上传列表JS
             var demoListView = $('#demoList')
             ,uploadListIns = upload.render({
               elem: '#testList'
               ,url: '<%=request.getContextPath()%>/teacher/teacherUpload.do',
												size : 51200 //限制文件大小，单位 KB(50M = 51200)
												,
												accept : 'file',
												data : {
													"courseId": ${course.courseId}
												},
												multiple : true,
												auto : false,
												bindAction : '#testListAction',
												exts : 'zip|rar|7z|pdf|xls|doc|ppt|docx|gif|bmp|jpeg|png|swf|svg|jpg|tiff|avi|mp4|rm|mov|asf|wmv|mkv|flv|mp3|wma|wav|asf|aac|mp3pro|vqf|flac',
												choose : function(obj) {
													var files = obj.pushFile(); //将每次选择的文件追加到文件队列
													//读取本地文件
													obj
															.preview(function(
																	index,
																	file,
																	result) {
																var tr = $([
																		'<tr id="upload-'+ index +'">',
																		'<td>'
																				+ file.name
																				+ '</td>',
																		'<td>'
																				+ (file.size / 1014)
																						.toFixed(1)
																				+ 'kb</td>',
																		'<td>等待上传</td>',
																		'<td>',
																		'<button class="layui-btn layui-btn-mini demo-reload layui-hide">重传</button>',
																		'<button class="layui-btn layui-btn-mini layui-btn-danger demo-delete">删除</button>',
																		'</td>',
																		'</tr>' ]
																		.join(''));

																//单个重传
																tr
																		.find(
																				'.demo-reload')
																		.on(
																				'click',
																				function() {
																					obj
																							.upload(
																									index,
																									file);
																				});

																//删除
																tr
																		.find(
																				'.demo-delete')
																		.on(
																				'click',
																				function() {
																					delete files[index]; //删除对应的文件
																					tr
																							.remove();
																				});

																demoListView
																		.append(tr);
															});
												},
												done : function(res, index,
														upload) {
													if (res.code == 0) { //上传成功
														var tr = demoListView.find('tr#upload-'+ index), tds = tr.children();
														tds.eq(2).html('<span style="color: #5FB878;">上传成功</span>');
														tds.eq(3).html(''); //清空操作
														delete files[index]; //删除文件队列已经上传成功的文件
														getPrivateData();
														return;
													}
													this.error(index, upload);
												},
												error : function(index, upload) {
													var tr = demoListView
															.find('tr#upload-'
																	+ index), tds = tr
															.children();
													tds
															.eq(2)
															.html(
																	'<span style="color: #FF5722;">上传失败</span>');
													tds
															.eq(3)
															.find(
																	'.demo-reload')
															.removeClass(
																	'layui-hide'); //显示重传
												}
											});
								});
			</script>

		</div>
		      
	</div>
	<script>
		layui.use([ 'element', 'layer', 'table' ], function() {
			var element = layui.element, $ = layui.jquery, table = layui.table;
			//监听导航点击
			element.on('nav(demo)', function(elem) {
				//console.log(elem)
				layer.msg(elem.text());
			});
			//转换静态表格
			table.init('recordTable', {
			//设置高度
			//支持所有基础参数
			});

		});
	</script>

</body>
</html>