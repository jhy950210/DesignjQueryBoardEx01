<%@ page language="java" contentType="text/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject"%>

<%@page import="javax.naming.Context"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.NamingException"%>
<%@page import="javax.sql.DataSource"%>

<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>

<% 
	request.setCharacterEncoding("utf-8");

	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	JSONArray jsonArray = new JSONArray();
	int flag = 1;
	
	try{
		Context initCtx = new InitialContext();
		Context envCtx = (Context)initCtx.lookup("java:comp/env");
		DataSource dataSource = (DataSource)envCtx.lookup("jdbc/mariadb1");
		
		conn = dataSource.getConnection();
		
		String sql = "select * from jquery_board";
		pstmt = conn.prepareStatement(sql);
		
		rs = pstmt.executeQuery();
		
		while( rs.next() ){
			String seq = rs.getString( "seq" );
			String subject = rs.getString( "subject" );
			String name = rs.getString( "name" );
			String mail = rs.getString( "mail" );
			String password = rs.getString( "password" );
			String content = rs.getString( "content" );
			
			JSONObject obj = new JSONObject();
			
			obj.put( "seq", seq );
			obj.put( "subject", subject );
			obj.put( "name", name );
			obj.put( "email", mail );
			obj.put( "password", password );
			obj.put( "content", content );
			
			jsonArray.add( obj );
			
			flag = 0;
		}
	} catch(NamingException e) {
		System.out.println("에러 : " + e.getMessage());
	} catch(SQLException e) {
		System.out.println("에러 : " + e.getMessage());		
	} finally {
		if(rs != null ) rs.close();
		if(pstmt != null ) pstmt.close();
		if(conn != null ) conn.close();
	}
	
	JSONObject result = new JSONObject();
	result.put("flag", flag);
	result.put("data", jsonArray);
	
	out.println(result);
%>