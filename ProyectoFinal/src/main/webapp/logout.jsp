<%-- 
    Document   : logout
    Created on : 12 may. 2025, 11:08:46
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    session.invalidate(); // Invalida la sesión actual
    response.sendRedirect("InicioPeliculaServlet"); // Redirige a tu página de inicio de sesión
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
