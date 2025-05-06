<%@page import="objetos.negocio.ControlUsuarios"%> 
<%@page import="objetos.negocio.Usuario"%> 
<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%
   
    String mensaje = "";

        // El usuario envia el formulario
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String nomUsuario = request.getParameter("nomUsuario");  // Se usa el nombre de usuario y contraseña para ingresar
        String contrasena = request.getParameter("contrasena");

        // Verificar las credenciales usando el nombre de usuario
        Usuario usuario = ControlUsuarios.buscarPorNombreUsuario(nomUsuario, contrasena);

        if (usuario != null) {
            // Si encontró al usuario, guardar el rol y nombre en sesión
            session.setAttribute("rol", usuario.getRol());
            session.setAttribute("nombreUsuario", usuario.getNombre());
            response.sendRedirect("usuarios.jsp"); // Redirige al menú principal
            return; // Detiene la ejecución para no seguir mostrando el login
        } else {
            mensaje = "Nombre de usuario o contraseña incorrectos.";
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Login de Usuarios</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="estilo.css">
    </head>
    <body class="bg-light">
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-md-4">
                    <div class="card shadow-sm">
                        <div class="card-header text-center">
                            <h4>Iniciar Sesión</h4>
                        </div>
                        <div class="card-body">
                            <% if (!mensaje.isEmpty()) {%>
                            <div class="alert alert-danger"><%= mensaje%></div>
                            <% }%>

                            <!-- Ingresan con el nombre de usuario y contraseña -->
                            <form method="post" action="login.jsp">
                                <div class="mb-3">
                                    <input type="text" class="form-control" name="nomUsuario" placeholder="Nombre de Usuario" required>
                                </div>
                                <div class="mb-3">
                                    <input type="password" class="form-control" name="contrasena" placeholder="Contraseña" required>
                                </div>
                                <div class="d-grid mb-3">
                                    <button type="submit" class="btn btn-primary">Entrar</button>
                                </div>
                            </form>
                            <div class="text-center">
                                <p>¿No tienes cuenta? <a href="registro.jsp">Regístrate aquí</a></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Scripts de Bootstrap -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</body>
</html>