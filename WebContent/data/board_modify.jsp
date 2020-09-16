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

	String seq = request.getParameter("seq");
	String subject = request.getParameter("subject");
	String name = request.getParameter("name");
	String mail = request.getParameter("mail");
	String password = request.getParameter("password");
	String content = request.getParameter("content");

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
		
		String sql = "update jquery_board set subject = ?, name = ?, mail = ?, content = ? where seq = ? and password = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1,subject);
	    pstmt.setString(2,name);
	    pstmt.setString(3,mail);
	    pstmt.setString(4,content);
	    pstmt.setString(5,seq);
	    pstmt.setString(6,password);
		
	    rs = pstmt.executeQuery();
		
		if(  pstmt.executeUpdate() == 1 ){
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
	
	out.println(result);
%>