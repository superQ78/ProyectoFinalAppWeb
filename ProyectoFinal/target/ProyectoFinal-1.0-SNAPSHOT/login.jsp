<%@ page session="true" %>
<%@page import="DAO.UsuariosDAO"%> 
<%@page import="DTO.UsuarioDTO"%> 
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String mensaje = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String nomUsuario = request.getParameter("nomUsuario");
        String contrasena = request.getParameter("contrasena");

        UsuarioDTO usuario = UsuariosDAO.buscarPorNombreUsuario(nomUsuario, contrasena);

        if (usuario != null) {
            session.setAttribute("rol", usuario.getRol());
            session.setAttribute("nombreUsuario", usuario.getNombre());
            response.sendRedirect("usuarios.jsp");
            return;
        } else {
            mensaje = "Nombre de usuario o contraseña incorrectos.";
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Iniciar Sesión | Filmoteca</title>
        <link rel="stylesheet" href="estiloLogin.css">
    </head>
    <body class="bg-light">
        <div class="login-container">
            <div class="card shadow-sm">
                <div class="card-header text-center">
                    <h4>Iniciar Sesión</h4>
                </div>
                <div class="card-body">
                    <% if (!mensaje.isEmpty()) {%>
                    <div class="alert alert-danger"><%= mensaje%></div>
                    <% }%>

                    <form method="post" action="LoginServlet">
                        <input type="text" class="form-control" name="nomUsuario" placeholder="Nombre de Usuario" required>
                        <input type="password" class="form-control" name="contrasena" placeholder="Contraseña" required>
                        <button type="submit" class="btn btn-primary">Entrar</button>
                    </form>
                    <div class="text-center mt-3">
                        ¿No tienes cuenta? <a href="registro.jsp">Regístrate aquí</a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
