<%-- 
    Document   : ResultadosBusqueda
    Created on : 13 may 2025, 13:16:07
    Author     : equipo
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="DTO.PeliculaDTO"%>
<%@page import="java.util.List"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Resultados de Búsqueda</title>
        <link rel="stylesheet" href="estiloBusqueda.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    </head>
    <body>
        
        <h1>Resultados de la búsqueda: "<%= request.getAttribute("busqueda")%>"</h1>
   <div class="contenedor-principal">
            <!-- Botón de Inicio -->
            <div class="contenedor-boton">
                <button>
                <a href="InicioPeliculaServlet" class="btn-inicio">
                    <i class="fas fa-home"></i> Ir a Inicio
                </a></button>
            </div>
        <div class="resultados-container">
            <%
                List<PeliculaDTO> peliculas = (List<PeliculaDTO>) request.getAttribute("peliculas");
                if (peliculas != null && !peliculas.isEmpty()) {
                    for (PeliculaDTO p : peliculas) {
            %>
            <div class="pelicula-card" onclick="window.location.href = 'VerDetallesPeliculaServlet?id=<%= p.getId()%>'">
                <% if (p.getImagen() != null && !p.getImagen().isEmpty()) {%>
                <img src="<%= p.getImagen()%>" alt="Portada de <%= p.getTitulo()%>">
                <% } else { %>
                <div class="sin-imagen">Sin imagen</div>
                <% }%>
                <div class="info-pelicula">
                    <h2><%= p.getTitulo()%></h2>
                    <p>Descripción: <%= p.getDescripcion().substring(0, Math.min(p.getDescripcion().length(), 100))%>...</p>
                    <p>Género: <%= p.getGenero()%></p>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <p class="no-resultados">No se encontraron películas con ese título.</p>
            <%
                }
            %>
        </div>
    </body>
</html>
