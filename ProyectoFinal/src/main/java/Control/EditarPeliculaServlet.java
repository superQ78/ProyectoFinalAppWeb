/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Control;

import DAO.PeliculaDAO;
import DTO.PeliculaDTO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.bson.types.ObjectId;

@WebServlet("/EditarPeliculaServlet")
public class EditarPeliculaServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String usuarioId = (String) session.getAttribute("usuarioId");

        if (usuarioId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String peliculaId = request.getParameter("peliculaId");
        if (peliculaId == null || peliculaId.isEmpty()) {
            response.sendRedirect("VerPeliculas.jsp");
            return;
        }

        PeliculaDTO pelicula = PeliculaDAO.obtenerPorId(new ObjectId(peliculaId));

        if (pelicula == null || !pelicula.getUsuarioId().equals(usuarioId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tienes permisos");
            return;
        }

        request.setAttribute("pelicula", pelicula);
        request.getRequestDispatcher("editarPelicula.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String usuarioId = (String) session.getAttribute("usuarioId");

        if (usuarioId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String peliculaId = request.getParameter("peliculaId");
        if (peliculaId == null || peliculaId.isEmpty()) {
            response.sendRedirect("VerPeliculas.jsp");
            return;
        }

        String titulo = request.getParameter("titulo");
        String descripcion = request.getParameter("descripcion");
        String calificacionStr = request.getParameter("calificacion");
        String comentario = request.getParameter("comentario");
        String genero = request.getParameter("genero");
        boolean favorita = request.getParameter("favorita") != null;
        String imagen = request.getParameter("imagen"); // Considera cómo manejar la imagen en la edición

        int calificacion = 0;
        try {
            calificacion = Integer.parseInt(calificacionStr);
            if (calificacion < 1 || calificacion > 5) {
                calificacion = 0;
            }
        } catch (NumberFormatException e) {
            calificacion = 0;
        }

        PeliculaDTO pelicula = new PeliculaDTO(new ObjectId(peliculaId), usuarioId, titulo, descripcion,
                calificacion, favorita, imagen, comentario, genero); // Reutiliza la ruta de la imagen existente

        PeliculaDAO.actualizarPelicula(pelicula);

        response.sendRedirect("VerPeliculasServlet");
    }
}
