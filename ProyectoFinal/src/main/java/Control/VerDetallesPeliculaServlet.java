package Control;

/**
 *
 * @author equipo
 */
import DAO.PeliculaDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.bson.types.ObjectId;
import DTO.PeliculaDTO;
import DAO.PeliculaDAO;

@WebServlet("/VerDetallesPeliculaServlet")
public class VerDetallesPeliculaServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        HttpSession session = request.getSession(false);
        String usuarioId = (session != null) ? (String) session.getAttribute("usuarioId") : null;

        if (usuarioId == null || usuarioId.isEmpty()) {
            // El usuario no está logueado, redirigir a la página de login
            response.sendRedirect("login.jsp"); // Reemplaza "login.jsp" con tu página de inicio de sesión
            return;
        }

        if (idParam != null && !idParam.isEmpty()) {
            try {
                ObjectId peliculaId = new ObjectId(idParam);
                PeliculaDTO pelicula = PeliculaDAO.obtenerPorId(peliculaId);

                if (pelicula != null && pelicula.getUsuarioId().equals(usuarioId)) {
                    request.setAttribute("pelicula", pelicula);
                    request.getRequestDispatcher("VerDetallesPelicula.jsp").forward(request, response);
                } else {
                    // Manejar el caso en que no se encuentra la película o no pertenece al usuario
                    response.sendRedirect("FavoritosServlet?mensajeError=Película no encontrada o no pertenece a tu lista");
                }

            } catch (IllegalArgumentException e) {
                // Manejar el caso en que el ID no es un ObjectId válido
                response.sendRedirect("FavoritosServlet?mensajeError=ID de película inválido");
            }
        } else {
            // Manejar el caso en que no se proporciona el ID
            response.sendRedirect("FavoritosServlet?mensajeError=No se proporcionó el ID de la película");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
