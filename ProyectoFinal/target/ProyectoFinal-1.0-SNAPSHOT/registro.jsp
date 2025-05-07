<%@page import="objetos.negocio.ControlUsuarios"%> 
<%@page import="objetos.negocio.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Variables para almacenar el mensaje que se mostrará al usuario y el estado del registro
    String mensaje = "";
    boolean registroExitoso = false;

    // Verifica si la solicitud es recibida
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");
        String nomUsuario = request.getParameter("nomUsuario"); // Obtener el nombre de usuario

        // Validación de que todos los campos estén llenos
        if (nombre == null || nombre.isEmpty()
                || correo == null || correo.isEmpty()
                || contrasena == null || contrasena.isEmpty()
                || nomUsuario == null || nomUsuario.isEmpty()) {
            mensaje = "Todos los campos son obligatorios.";
        } else {
            // Validar si ya existe un usuario con el mismo correo
            Usuario usuarioExistenteCorreo = ControlUsuarios.buscarPorCorreo(correo);
            if (usuarioExistenteCorreo != null) {
                mensaje = "Ya existe un usuario registrado con ese correo.";
            } else {
                // Validar si ya existe un nombre de usuario
                Usuario usuarioExistenteNombre = ControlUsuarios.buscarPorNombreUsuario(nomUsuario, contrasena);
                if (usuarioExistenteNombre != null) {
                    mensaje = "Ya existe un usuario registrado con ese nombre de usuario.";
                } else {
                    // Crear el nuevo usuario con rol por defecto usuario
                    Usuario nuevoUsuario = new Usuario(nomUsuario, nombre, correo, contrasena, "usuario");
                    boolean registro = ControlUsuarios.agregar_usuario(nuevoUsuario);
                    if (registro) {
                        mensaje = "Registro exitoso.";
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
        <title>Registro de Usuario</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="estilo.css">
        <% if (registroExitoso) { %>
        <meta http-equiv="refresh" content="3;URL=login.jsp">
        <% } %>
    </head>
    <body>
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header text-center">
                            <h4>Registrarse</h4>
                        </div>
                        <div class="card-body">
                            <% if (!mensaje.isEmpty()) {%>
                            <div class="alert alert-<%= registroExitoso ? "success" : "danger"%>">
                                <%= mensaje%>
                            </div>
                            <% }%>
                            <form method="post" action="registro.jsp">
                                <div class="mb-3">
                                    <input type="text" class="form-control" name="nomUsuario" placeholder="Nombre de Usuario" required>
                                </div>
                                <div class="mb-3">
                                    <input type="text" class="form-control" name="nombre" placeholder="Nombre Completo" required>
                                </div>
                                <div class="mb-3">
                                    <input type="email" class="form-control" name="correo" placeholder="Correo Electrónico" required>
                                </div>
                                <div class="mb-3">
                                    <input type="password" class="form-control" name="contrasena" placeholder="Contraseña" required>
                                </div>
                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">Registrarse</button>
                                    <a href="login.jsp" class="btn btn-secondary">Cancelar</a>
                                </div>
                            </form>
                            <div class="text-center">
                                <a href="login.jsp">¿Ya tienes cuenta? Inicia sesión</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Scripts de Bootstrap -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>