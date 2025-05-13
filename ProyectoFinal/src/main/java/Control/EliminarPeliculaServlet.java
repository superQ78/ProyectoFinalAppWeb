package Control;

import Negocio.PeliculaBO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Equipo
 */
@WebServlet("/EliminarPeliculaServlet")
public class EliminarPeliculaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String peliculaId = request.getParameter("peliculaId");

        if (peliculaId == null || peliculaId.isEmpty()) {
            System.out.println("⚠ Error: ID de película vacío o inválido.");
            response.sendRedirect("VerPeliculasServlet");
            return;
        }

        System.out.println("🗑️ Eliminando película con ID: " + peliculaId);

        PeliculaBO peliculaBO = new PeliculaBO();
        peliculaBO.eliminarPelicula(peliculaId);

        System.out.println("✅ Película eliminada correctamente.");
        response.sendRedirect("VerPeliculasServlet"); 
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}