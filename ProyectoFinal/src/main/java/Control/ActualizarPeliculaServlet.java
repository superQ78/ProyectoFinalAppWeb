/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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

@WebServlet("/ActualizarPeliculaServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 1024 * 1024 * 5,       // 5 MB
    maxRequestSize = 1024 * 1024 * 10    // 10 MB
)
public class ActualizarPeliculaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String usuarioId = (String) session.getAttribute("usuarioId");
        
        if (usuarioId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Obtener parámetros del formulario
            String peliculaId = request.getParameter("peliculaId");
            String titulo = request.getParameter("titulo");
            String descripcion = request.getParameter("descripcion");
            int calificacion = Integer.parseInt(request.getParameter("calificacion"));
            boolean favorita = request.getParameter("favorita") != null;
            String comentario = request.getParameter("comentario");
            String genero = request.getParameter("genero");
            String imagenActual = request.getParameter("imagenActual");

            // Procesar imagen
            String imagenPath = imagenActual;
            Part filePart = request.getPart("imagen");
            
            if (filePart != null && filePart.getSize() > 0) {
                // Eliminar imagen anterior si existe
                if (imagenActual != null && !imagenActual.isEmpty()) {
                    File oldImage = new File(getServletContext().getRealPath(imagenActual));
                    if (oldImage.exists()) {
                        oldImage.delete();
                    }
                }
                
                // Guardar nueva imagen
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("/uploads");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                imagenPath = "uploads/" + fileName;
            }

            // Crear DTO y actualizar
            PeliculaDTO pelicula = new PeliculaDTO(
                new ObjectId(peliculaId),
                usuarioId,
                titulo,
                descripcion,
                calificacion,
                favorita,
                imagenPath,
                comentario,
                genero
            );

            boolean exito = PeliculaDAO.actualizarPelicula(pelicula);
            
            if (exito) {
        response.sendRedirect("VerPeliculasServlet"); 
            } else {
                request.setAttribute("error", "Error al actualizar la película");
                request.getRequestDispatcher("editarPelicula.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("editarPelicula.jsp").forward(request, response);
        }
    }
}
