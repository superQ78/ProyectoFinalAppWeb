<%@page import="DAO.UsuariosDAO"%> 
<%@page import="DTO.UsuarioDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String mensaje = "";
    boolean registroExitoso = false;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");
        String nomUsuario = request.getParameter("nomUsuario");

        if (nombre == null || nombre.isEmpty()
                || correo == null || correo.isEmpty()
                || contrasena == null || contrasena.isEmpty()
                || nomUsuario == null || nomUsuario.isEmpty()) {
            mensaje = "Todos los campos son obligatorios.";
        } else {
            UsuarioDTO usuarioExistenteCorreo = UsuariosDAO.buscarPorCorreo(correo);
            if (usuarioExistenteCorreo != null) {
                mensaje = "Ya existe un usuario registrado con ese correo.";
            } else {
                UsuarioDTO usuarioExistenteNombre = UsuariosDAO.buscarPorNombreUsuario(nomUsuario, contrasena);
                if (usuarioExistenteNombre != null) {
                    mensaje = "Ya existe un usuario registrado con ese nombre de usuario.";
                } else {
                    UsuarioDTO nuevoUsuario = new UsuarioDTO(nomUsuario, nombre, correo, contrasena, "usuario");
                    boolean registro = UsuariosDAO.agregar_usuario(nuevoUsuario);
                    if (registro) {
                        mensaje = "Registro exitoso. Serás redirigido al login.";
                        registroExitoso = true;
                    } else {
                        mensaje = "Error al registrar el usuario. Intenta nuevamente.";
                    }
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Registro | Filmoteca</title>
        <link rel="stylesheet" href="estiloRegistro.css">
        <% if (registroExitoso) { %>
        <meta http-equiv="refresh" content="3;URL=login.jsp">
        <% } %>
    </head>
    <body>
        <div class="container">
            <div class="card-header">
                REGISTRO DE USUARIO
            </div>
            <div class="card-body">
                <% if (!mensaje.isEmpty()) {%>
                <div class="alert alert-<%= registroExitoso ? "success" : "danger"%>">
                    <%= mensaje%>
                </div>
                <% }%>
                <form method="post" action="registro.jsp">
                    <input type="text" name="nomUsuario" placeholder="Nombre de Usuario" required>
                    <input type="text" name="nombre" placeholder="Nombre Completo" required>
                    <input type="email" name="correo" placeholder="Correo Electrónico" required>
                    <input type="password" name="contrasena" placeholder="Contraseña" required>

                    <button type="submit" class="btn btn-primary">Registrarse</button>
                    <a href="login.jsp" class="btn btn-secondary">Cancelar</a>
                </form>
                <div class="text-center">
                    ¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión aquí</a>
                </div>
            </div>
        </div>
    </body>
</html>