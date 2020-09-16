<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="./css/base/jquery-ui.css" />
<style type="text/css">
    body { font-size: 70%; }
     #accordion-resizer {
          margin: 0 60px;
          max-width: 1500px;
     }
     #btngroup1 {
          text-align: right;
     }
     label.header {
          font-size: 10pt;
          margin-right: 5px;
     }

     input.text {
          width: 80%;
          margin-bottom: 12px;
          padding: .4em;
     }

     fieldset {
          margin-left: 15px;
          margin-top: 15px;
          border: 0;
     }
</style>
<script type="text/javascript" src="./js/jquery-3.5.1.js"></script>
<script type="text/javascript" src="./js/jquery-ui.js"></script>
<script type="text/javascript">
    $(document).ready(function() {
        $('#accordion').accordion({
        	
            heightStyle: 'content'
        });

        $("#writeDialog").css('display', 'none');
        $("#modifyDialog").css('display', 'none');
        $("#deleteDialog").css('display', 'none');

        // 1
        
        $('button.action').button().on('click', function() {
            if($(this).attr('action') == 'write') {
                $('#writeDialog').dialog({
                    width: 700,
                    height: 500,
                    modal: true,
                    buttons: {
                         "글쓰기": function() {
                        	var subject = $( '#w_subject' ).val();
         					var name = $( '#w_writer' ).val();
         					var mail = $( '#w_mail' ).val();
         					var password = $( '#w_password' ).val();
         					var content = $( '#w_content' ).val();
         					
         					// 데이터의 검사 구문
         					writeServer( subject, name, mail, password, content );
                            //$(this).dialog('close');
                         },
                         "취소": function() {
                             $(this).dialog('close');
                         }
                    }
                });
            } else if($(this).attr('action') == 'modify') {
                $('#modifyDialog').dialog({
                    width: 700,
                    height: 500,
                    modal: true,
                    buttons: {
                         "글수정": function() {
                             $(this).dialog('close');
                         },
                         "취소": function() {
                             $(this).dialog('close');
                         }
                    }
                });
            } else if($(this).attr('action') == 'delete') {
                $('#deleteDialog').dialog({
                    width: 700,
                    height: 200,
                    modal: true,
                    buttons: {
                         "글삭제": function() {
                             $(this).dialog('close');
                         },
                         "취소": function() {
                             $(this).dialog('close');
                         }
                    }
                });
            } 
        });
        listServer();
    });
    
    var listData = function( data ) {
    	$( '#accordion' ).empty();
    	$.each(data, function(index, item){
    		var html = '';
    		html += '<h3>' + item.seq + ' ' + item.subject + '<h3>';
    		html += '	<div style="width: 80%; float: left;">' + item.content  + '</div>';
    		html += '	<div style="text-align:right; vertical-align:bottom;">';
    		html += '		<button seq="'+ item.seq +'"action="modify" class="action">수정</button>';	
    		html += '		<button idx="'+ item.seq +'"action="delete" class="action">삭제</button>';
    		html += '	</div>';
    		html += '</div>';
    		
    		$( '#accordion' ).append(html);
    		$( '#accordion' ).accordion( 'refresh' );
    		
    		$('button.action').button().on('click', function() {
    	           if($(this).attr('action') == 'modify') {
    	                $('#modifyDialog').dialog({
    	                	var subject = item.subject;
    	                	 
    	                    width: 700,
    	                    height: 500,
    	                    modal: true,
    	                    buttons: {
    	                         "글수정": function() {
    	                             $(this).dialog('close');
    	                         },
    	                         "취소": function() {
    	                             $(this).dialog('close');
    	                         }
    	                    }
    	                });
    	            } else if($(this).attr('action') == 'delete') {
    	                $('#deleteDialog').dialog({
    	                    width: 700,
    	                    height: 200,
    	                    modal: true,
    	                    buttons: {
    	                         "글삭제": function() {
    	                             $(this).dialog('close');
    	                         },
    	                         "취소": function() {
    	                             $(this).dialog('close');
    	                         }
    	                    }
    	                });
    	            } 
    	        });
    	});
	};
	
	var listServer = function() {
		$.ajax({
			url: './data/board_list.jsp',
			type: 'get',
			dataType: 'json',
			success: function( json ) {
				listData( json.data );
				
			},
			error: function( error ) {
				console.log( '[에러] ' + error.status );
				console.log( '[에러] ' + error.responseText );
			}
		});
	};
	
	var writeServer = function(subject, name, mail, password, content){
		$.ajax({
			url: './data/board_write.jsp',
			data: {
				subject: subject,
				name: name,
				mail: mail,
				password: password,
				content: content
			},
			type: 'get',
			datatype: 'json',
			success: function( json ) {
				console.log(json.log);
				if( json.flag == 0 ){
					$('#writeDialog').dialog( 'close' );
					listServer();	
				}
				
			}
		});
	};
	
</script>
</head>
<body>

<div id="accordion-resizer">
    <div id="btngroup1">
        <button action="write" class="action">글쓰기</button>
    </div>
    <br /><hr /><br />
    <div id="accordion">
        
    </div>
</div>

<div id="writeDialog" title="글쓰기"> 
     <fieldset>
          <div>
               <label for="subject" class="header">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</label>
               <input type="text" id="w_subject" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="writer" class="header">이&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;름</label>
               <input type="text" id="w_writer" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="mail" class="header">메&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;일</label>
               <input type="text" id="w_mail" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="password" class="header">비밀&nbsp;번호</label>
               <input type="password" id="w_password" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="content" class="header">본&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;문</label>
               <br />
               <textarea rows="15" cols="100" id="w_content" class="text ui-widget-content ui-corner-all">               </textarea>
          </div>
     </fieldset>
</div>

<div id="modifyDialog" title="글수정"> 
     <fieldset>
          <div>
               <label for="subject" class="header">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</label>
               <input type="text" id="m_subject" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="writer" class="header">이&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;름</label>
               <input type="text" id="m_writer" class="text ui-widget-content ui-corner-all" readonly="readonly"/>
          </div>
          <div>
               <label for="mail" class="header">메&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;일</label>
               <input type="text" id="m_mail" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="password" class="header">비밀&nbsp;번호</label>
               <input type="password" id="m_password" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="content" class="header">본&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;문</label>
               <br/>
               <textarea rows="15" cols="100" id="m_content" class="text ui-widget-content ui-corner-all"></textarea>
          </div>
     </fieldset>
</div>

<div id="deleteDialog" title="글삭제"> 
     <fieldset>
          <div>
               <label for="subject" class="header">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</label>
               <input type="text" id="d_subject" class="text ui-widget-content ui-corner-all" readonly="readonly"/>
          </div>
          <div>
               <label for="password" class="header">비밀&nbsp;번호</label>
               <input type="password" id="d_password" class="text ui-widget-content ui-corner-all"/>
          </div>
     </fieldset>
</div>

</body>
</html>
