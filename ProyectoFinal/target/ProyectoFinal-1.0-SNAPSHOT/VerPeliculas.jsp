<%@ page session="true" %>
<%@ page import="java.util.List, DTO.PeliculaDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    Object peliculasObj = request.getAttribute("listaPeliculas");
    List<PeliculaDTO> listaPeliculas = (peliculasObj instanceof List<?>)
            ? (List<PeliculaDTO>) peliculasObj : new ArrayList<>();
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Mis Películas</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <link rel="stylesheet" href="estiloVerPelicula.css">
        <script>
            function toggleFavorito(peliculaId, boton) {
                fetch("ToggleFavoritoServlet", {
                    method: "POST",
                    body: new URLSearchParams({peliculaId: peliculaId})
                }).then(response => {
                    if (response.ok) {
                        boton.children[0].classList.toggle("fas");
                        boton.children[0].classList.toggle("far");
                    }
                }).catch(error => console.error("Error al marcar favorito:", error));
            }
        </script>
    </head>
    <body>
        <h1>Mis Películas</h1>
        <button onclick="window.location.href = 'InicioPeliculaServlet'" class="btn-atras">Atrás</button>
        <button onclick="window.location.href = 'FavoritosServlet'" class="btn-favoritos-link">
            <i class="fas fa-heart"></i> Ir a Favoritos
        </button>
        
        <div class="peliculas-container">
            <% if (listaPeliculas.isEmpty()) { %>
                <p>No tienes películas registradas aún.</p>
            <% } else { 
                for (PeliculaDTO pelicula : listaPeliculas) { 
                    String imagenUrl = pelicula.getImagen();
                    if (imagenUrl == null || imagenUrl.isEmpty()) {
                        imagenUrl = "images/default.jpg";
                    }
            %>
                <div class="pelicula">
                    <img src="<%= imagenUrl%>" alt="Portada de <%= pelicula.getTitulo()%>" class="portada-img">
                    <h2><%= pelicula.getTitulo()%></h2>
                    <p><%= pelicula.getDescripcion()%></p>
                    <p>🎭 Género: <%= pelicula.getGenero()%></p>
                    <p>⭐ Calificación: <%= pelicula.getCalificacion()%>/5</p>

                    <button class="btn-favorito" onclick="toggleFavorito('<%= pelicula.getId()%>', this)">
                        ⭐ <i class="<%= pelicula.isFavorita() ? "fas" : "far" %> fa-star"></i>
                    </button>

                    <div class="acciones-pelicula">
                        <a href="EditarPeliculaServlet?peliculaId=<%= pelicula.getId()%>" class="btn-editar">
                            ✏️ Editar
                        </a>
                        <form action="EliminarPeliculaServlet" method="post" class="form-accion" 
                              onsubmit="return confirm('¿Seguro que deseas eliminar esta película?');">
                            <input type="hidden" name="peliculaId" value="<%= pelicula.getId()%>">
                            <button type="submit" class="btn-eliminar">🗑️ Eliminar</button>
                        </form>
                    </div>
                </div>
            <% } 
            } %>
        </div>
    </body>
</html>