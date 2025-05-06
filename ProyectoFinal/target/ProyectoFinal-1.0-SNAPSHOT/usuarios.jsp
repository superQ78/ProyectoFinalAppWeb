<%@page import="org.bson.types.ObjectId"%>
<%@page import="java.util.List"%>
<%@page import="objetos.negocio.ControlUsuarios"%>
<%@page import="objetos.negocio.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String accion = request.getParameter("accion");

    Usuario usuarioEditar = null;

    // Agrega un nuevo usuario
    if ("agregar".equals(accion)) {
        String nomUsuario = request.getParameter("nomUsuario");
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");
        String rol = request.getParameter("rol");  // puede ser administardor o usuario
        Usuario usuario = new Usuario(nomUsuario, nombre, correo, contrasena, rol);
        ControlUsuarios.agregar_usuario(usuario);
    }

    //Editar un usuario existente
    if ("editar".equals(accion)) {
        String idStr = request.getParameter("id");
        ObjectId id = new ObjectId(idStr);
        String nomUsuario = request.getParameter("nomUsuario");
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");
        String rol = request.getParameter("rol");

        Usuario usuario = new Usuario(id, nomUsuario, nombre, correo, contrasena, rol);
        ControlUsuarios.actualizar_usuario(usuario);
    }

    //Eliminar un usuario
    if ("eliminar".equals(accion)) {
        String idStr = request.getParameter("id");
        ObjectId id = new ObjectId(idStr);
        ControlUsuarios.eliminar_usuario(id);
    }

    // Verificar si se quiere editar un usuario 
    String idEditar = request.getParameter("idEditar");
    if (idEditar != null && !idEditar.isEmpty()) {
        usuarioEditar = ControlUsuarios.obtener_por_id(new ObjectId(idEditar));
    }

    // obtiene el rol de usuario desde sesión
    String rolUsuario = (String) session.getAttribute("rol");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Usuarios</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="estiloUsuario.css">
    </head>
    <body class="bg-light">
        <div class="container py-4">
            <h1 class="mb-4">Gestión de Usuarios</h1>

            <% if ("admin".equals(rolUsuario)) { %>

            <!-- Formulario para agregar o editar usuario -->
            <div class="card mb-4">
                <div class="card-header">
                    <% if (usuarioEditar != null) { %> Editar Usuario <% } else { %> Agregar nuevo usuario <% }%>
                </div>
                <div class="card-body">
                    <form action="usuarios.jsp" method="post" class="row g-3">
                        <input type="hidden" name="accion" value="<%= (usuarioEditar != null) ? "editar" : "agregar"%>">
                        <% if (usuarioEditar != null) {%>
                        <input type="hidden" name="id" value="<%= usuarioEditar.getId()%>">
                        <% }%>

                        <div class="col-md-2">
                            <label class="form-label">Nombre de Usuario</label>
                            <input type="text" name="nomUsuario" class="form-control" value="<%= (usuarioEditar != null) ? usuarioEditar.getNomUsuario() : ""%>" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Nombre</label>
                            <input type="text" name="nombre" class="form-control" value="<%= (usuarioEditar != null) ? usuarioEditar.getNombre() : ""%>" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Correo</label>
                            <input type="email" name="correo" class="form-control" value="<%= (usuarioEditar != null) ? usuarioEditar.getCorreo() : ""%>" required>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Contraseña</label>
                            <input type="password" name="contrasena" class="form-control" value="<%= (usuarioEditar != null) ? usuarioEditar.getContrasena() : ""%>" required>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Rol</label>
                            <select name="rol" class="form-control" required>
                                <option value="usuario" <%= (usuarioEditar != null && "Usuario".equals(usuarioEditar.getRol())) ? "selected" : ""%>>Usuario</option>
                                <option value="admin" <%= (usuarioEditar != null && "Administrador".equals(usuarioEditar.getRol())) ? "selected" : ""%>>Administrador</option>
                            </select>
                        </div>

                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">
                                <%= (usuarioEditar != null) ? "Actualizar usuario" : "Guardar usuario"%>
                            </button>
                            <% if (usuarioEditar != null) { %>
                            <a href="usuarios.jsp" class="btn btn-secondary">Cancelar</a>
                            <% } %>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Tabla de usuarios -->
            <div class="card">
                <div class="card-header">Lista de usuarios</div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-bordered m-0">
                            <thead class="table-dark">
                                <tr>
                                    <th>Nombre de Usuario</th>
                                    <th>Nombre</th>
                                    <th>Correo</th>
                                    <th>Rol</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Usuario> lista = ControlUsuarios.obtener_lista(rolUsuario);
                                    for (Usuario usuario : lista) {
                                %>
                                <tr>
                                    <td><%= usuario.getNomUsuario()%></td>
                                    <td><%= usuario.getNombre()%></td>
                                    <td><%= usuario.getCorreo()%></td>
                                    <td><%= usuario.getRol()%></td>
                                    <td>
                                        <div class="d-flex justify-content-center gap-2">
                                            <!-- Botón Editar -->
                                            <form action="usuarios.jsp" method="get" style="display:inline;">
                                                <input type="hidden" name="idEditar" value="<%= usuario.getId()%>">
                                                <button type="submit" class="btn btn-warning btn-sm px-3">Editar</button>
                                            </form>

                                            <!-- Botón Eliminar -->
                                            <form action="usuarios.jsp" method="post" style="display:inline;" onsubmit="return confirmarEliminacion();">
                                                <input type="hidden" name="accion" value="eliminar">
                                                <input type="hidden" name="id" value="<%= usuario.getId()%>">
                                                <button type="submit" class="btn btn-danger btn-sm px-3">Eliminar</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <% }%>
        </div>

        <!-- Confirmación para eliminar -->
        <script>
            function confirmarEliminacion() {
                return confirm('¿Está seguro de que desea eliminar este usuario?');
            }
        </script>
        <!-- Scripts de Bootstrap -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>