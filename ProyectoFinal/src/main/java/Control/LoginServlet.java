package Control;

import DAO.UsuariosDAO;
import DTO.UsuarioDTO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author equipo
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lógica para mostrar el formulario de inicio de sesión
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nomUsuario = request.getParameter("nomUsuario");
        String contrasena = request.getParameter("contrasena");

        UsuarioDTO usuario = UsuariosDAO.buscarPorNombreUsuario(nomUsuario, contrasena);

        if (usuario != null) {
            HttpSession session = request.getSession();
            session.setAttribute("rol", usuario.getRol());
            session.setAttribute("nombreUsuario", usuario.getNombre());

            session.setAttribute("usuarioId", usuario.getId().toHexString()); // ✅ Guarda como String
            System.out.println("Usuario guardado en sesión correctamente: " + session.getAttribute("usuarioId"));

            // Depuración en consola
            System.out.println("Usuario guardado en sesión: " + session.getAttribute("usuarioId"));

            if ("admin".equalsIgnoreCase(usuario.getRol())) {
                response.sendRedirect("usuarios.jsp");
            } else {
                response.sendRedirect("InicioPeliculaServlet");
            }
        } else {
            request.setAttribute("mensaje", "Nombre de usuario o contraseña incorrectos.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
