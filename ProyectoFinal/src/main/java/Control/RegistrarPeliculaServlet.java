
package Control;

import DAO.PeliculaDAO;
import DTO.PeliculaDTO;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import org.bson.types.ObjectId;

@WebServlet("/RegistrarPeliculaServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // Permite archivos de hasta 5MB
public class RegistrarPeliculaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
         request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        String usuarioId = (String) session.getAttribute("usuarioId");

        if (usuarioId == null || usuarioId.isEmpty()) {
            System.out.println("⚠ Error: No hay usuario en sesión. Redirigiendo a login.");
            response.sendRedirect("login.jsp");
            return;
        }

        // Capturar datos desde el formulario
        String titulo = request.getParameter("titulo");
        String descripcion = request.getParameter("descripcion");
        String calificacionStr = request.getParameter("calificacion");
        String comentario = request.getParameter("comentario");
        String genero = request.getParameter("genero");
        boolean favorita = request.getParameter("favorita") != null;

        // Validar calificación
        int calificacion = 0;
        try {
            calificacion = Integer.parseInt(calificacionStr);
            if (calificacion < 1 || calificacion > 5) {
                calificacion = 0; // Evitar valores fuera del rango permitido
            }
        } catch (NumberFormatException e) {
            calificacion = 0;
        }

        // Obtener ruta absoluta de almacenamiento usando getRealPath sobre /uploads
        String uploadPath = getServletContext().getRealPath("/uploads");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs(); // Si no existe, se crea la carpeta automáticamente
        }

        // Procesar subida de imagen
        Part filePart = request.getPart("imagen");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String filePath = uploadPath + File.separator + fileName;

        // Guardar el archivo solo si hay imagen
        String imagePath = null;
        if (fileName != null && !fileName.isEmpty()) {
            filePart.write(filePath);
            // Guardamos la ruta relativa que usaremos en nuestras páginas JSP
            imagePath = "uploads/" + fileName;
            System.out.println("✅ Imagen guardada en: " + filePath);
        } else {
            System.out.println("⚠ No se recibió ninguna imagen.");
        }

        // Validar datos esenciales
        if (titulo == null || titulo.isEmpty() || descripcion == null || descripcion.isEmpty()) {
            request.setAttribute("errorMensaje", "Título y descripción son obligatorios.");
            request.getRequestDispatcher("RegistrarPelicula.jsp").forward(request, response);
            return;
        }

        // Crear DTO y guardar en la BD
        PeliculaDTO pelicula = new PeliculaDTO(new ObjectId(), usuarioId, titulo, descripcion, 
            calificacion, favorita, imagePath, comentario, genero);
        PeliculaDAO.agregar(pelicula);

        System.out.println("✅ Película registrada correctamente en la BD.");
        response.sendRedirect("VerPeliculasServlet"); 
    }
}