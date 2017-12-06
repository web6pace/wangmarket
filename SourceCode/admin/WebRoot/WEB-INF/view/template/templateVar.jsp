<%@page import="com.xnx3.j2ee.Global"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.xnx3.admin.G"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<jsp:include page="../iw/common/head.jsp">
	<jsp:param name="title" value="编辑模版变量"/>
</jsp:include>

<form id="form" class="layui-form layui-form-pane" action="saveTemplateVar.do" method="post" style="padding:5px;">
  <input type="hidden" name="id" value="${templateVar.id }" />
  <div class="layui-form-item" style="">
    <label class="layui-form-label">变量名</label>
    <div class="layui-input-inline">
      <input type="text" name="varName" lay-verify="varName" placeholder="请输入变量名字" autocomplete="off" class="layui-input" value="${templateVar.varName }">
    </div>
    <div class="layui-form-mid" style=" margin-top: -8px;">
    	可再模版中使用&nbsp;{include=变量名}&nbsp;调用<br/>
    	建议设置后就不要对其进行改动了，模版页面调用、备份还原都是依据此处。
    </div>
  </div>
  <div class="layui-form-item" style="">
    <label class="layui-form-label">备注</label>
    <div class="layui-input-inline">
      <input type="text" name="remark" lay-verify="remark" placeholder="给自己备注，无其他作用" autocomplete="off" class="layui-input" value="${templateVar.remark }">
    </div>
    <div class="layui-form-mid">仅给网站操作人员备注提示使用，无实际作用</div>
  </div>
  <div class="layui-form-item layui-form-text" style="height: 80%;">
    <label class="layui-form-label">模版变量代码</label>
    <div class="layui-input-block">
      <textarea name="text" style="height:400px;" lay-verify="text" placeholder="请输入模版变量代码，注意，请不要将head、body标签放到模版变量里面！" class="layui-textarea" style="height: 95%;">${text }</textarea>
    </div>
  </div>
  <div style="font-size:14px; margin-top:-5px;">
  		可用标签：
    	<a href="javascript:popupTemplateTagHelp('通用标签','tongyongTable', '380', '560');" style="border: 1px solid #e6e6e6; padding: 5px; padding-left: 8px; padding-right: 8px;">通用标签</a>
    	<a href="javascript:popupTemplateTagHelp('动态栏目调用','dongtailanmuTable','770', '565');" style="border: 1px solid #e6e6e6; padding: 5px; padding-left: 8px; padding-right: 8px;">动态栏目调用标签</a>
  </div>
  <div class="layui-form-item" style="text-align:center;">
  	<button class="layui-btn" lay-submit="" lay-filter="demo1">保存</button>
  </div>
</form>

<script>
layui.use(['form', 'layedit', 'laydate'], function(){
  var form = layui.form;
 
  //自定义验证规则
  form.verify({
    varName: function(value){
      if(value.length == 0){
        return '请输入变量的名字';
      }
      if(value.length > 20){
      	return '请输入20个字以内的变量名字';
      }
    }
  });
  
  //监听提交
  form.on('submit(demo1)', function(data){
  	  $.showLoading('数据保存中');
		var d=$("form").serialize();
        $.post("<%=basePath %>template/saveTemplateVar.do", d, function (result) { 
        	$.hideLoading();
        	var obj = JSON.parse(result);
        	if(obj.result == '1'){
        		$.toast("保存成功", function() {
        			window.location.href="templateVarList.do";
		        });
        	}else if(obj.result == '0'){
        		layer.msg(obj.info, {shade: 0.3})
        	}else{
        		layer.msg(result, {shade: 0.3})
        	}
         }, "text");
		
    return false;
  });
  
});

/**
 * 弹出模版标签帮助窗口
 * @param title 窗口的标题文字
 * @param htmlNameTag 帮助的网址后面的描点名字
 * @param height 弹出窗口的宽度,整数。会自动拼接px
 * @param height 弹出窗口的高度,整数。会自动拼接px
 */ 
function popupTemplateTagHelp(title,htmlNameTag, width, height){
	var url = '';
	if(htmlNameTag.indexOf('http://') > -1){
		url = htmlNameTag;
	}else{
		url = 'http://res.weiunity.com/html/templateTag/index.html#'+htmlNameTag;
	}
	layer.open({
		type: 2 //iframe
		,title:title
		,area: [width+'px', height+'px']
		,shade: 0
		,offset: [ //为了演示，随机坐标
			Math.random()*($(window).height()-300)
			,Math.random()*($(window).width()-390)
		]
 		,maxmin: true
		,content: url
		,zIndex: layer.zIndex //重点1
		,success: function(layero){
			layer.setTop(layero); //重点2
  		}
	});
}
</script>

</body>
</html>