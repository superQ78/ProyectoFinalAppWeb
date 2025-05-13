    /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DTO.PeliculaDTO;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import static com.mongodb.client.model.Filters.eq;
import java.util.ArrayList;
import java.util.List;
import org.bson.Document;
import org.bson.types.ObjectId;

/**
 *
 * @author equipo
 */
public class PeliculaDAO {

    private static final MongoCollection<Document> peliculas;

    static {
        MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017");
        MongoDatabase database = mongoClient.getDatabase("biblioteca");
        peliculas = database.getCollection("peliculas");
    }

    public static void agregar(PeliculaDTO pelicula) {
        Document doc = new Document("usuarioId", pelicula.getUsuarioId().toString()) // 🔹 Guardar usuarioId como String
                .append("titulo", pelicula.getTitulo())
                .append("descripcion", pelicula.getDescripcion())
                .append("calificacion", pelicula.getCalificacion())
                .append("favorita", pelicula.isFavorita())
                .append("imagen", pelicula.getImagen())
                .append("comentario", pelicula.getComentario())
                .append("genero", pelicula.getGenero());

        peliculas.insertOne(doc);
    }

    public static List<PeliculaDTO> obtenerPorUsuario(String usuarioId) {
        List<PeliculaDTO> lista = new ArrayList<>();

        if (usuarioId == null || usuarioId.isEmpty()) {
            System.out.println("Error: usuarioId es nulo o vacío en obtenerPorUsuario()");
            return lista;
        }

        // 🔹 Debug: Mostrar qué usuario se está consultando en MongoDB
        System.out.println("Consultando películas para usuarioId: " + usuarioId);

        MongoCursor<Document> cursor = peliculas.find(eq("usuarioId", usuarioId)).iterator();

        while (cursor.hasNext()) {
            Document doc = cursor.next();
            System.out.println("Película encontrada: " + doc.getString("titulo"));

            lista.add(new PeliculaDTO(
                    doc.getObjectId("_id"),
                    doc.getString("usuarioId"),
                    doc.getString("titulo"),
                    doc.getString("descripcion"),
                    doc.getInteger("calificacion"),
                    doc.getBoolean("favorita"),
                    doc.getString("imagen"),
                    doc.getString("comentario"),
                    doc.getString("genero")
            ));
        }

        System.out.println("Películas encontradas: " + lista.size());
        return lista;
    }

    public static List<PeliculaDTO> obtenerFavoritasPorUsuario(String usuarioId) {
        List<PeliculaDTO> lista = new ArrayList<>();

        if (usuarioId == null || usuarioId.isEmpty()) {
            System.out.println("Error: usuarioId es nulo o vacío en obtenerFavoritasPorUsuario()");
            return lista;
        }

        MongoCursor<Document> cursor = peliculas.find(
                Filters.and(Filters.eq("usuarioId", usuarioId), Filters.eq("favorita", true))
        ).iterator();

        while (cursor.hasNext()) {
            Document doc = cursor.next();
            lista.add(new PeliculaDTO(
                    doc.getObjectId("_id"),
                    doc.getString("usuarioId"),
                    doc.getString("titulo"),
                    doc.getString("descripcion"),
                    doc.getInteger("calificacion"),
                    doc.getBoolean("favorita"),
                    doc.getString("imagen"),
                    doc.getString("comentario"),
                    doc.getString("genero")
            ));
        }

        return lista;
    }

    public static void eliminar(ObjectId id) {
        peliculas.deleteOne(eq("_id", id));
    }

    public static void actualizar(PeliculaDTO pelicula) {
        Document doc = new Document("usuarioId", pelicula.getUsuarioId())
                .append("titulo", pelicula.getTitulo())
                .append("descripcion", pelicula.getDescripcion())
                .append("calificacion", pelicula.getCalificacion())
                .append("favorita", pelicula.isFavorita())
                .append("imagen", pelicula.getImagen())
                .append("genero", pelicula.getGenero());
        peliculas.updateOne(eq("_id", pelicula.getId()), new Document("$set", doc));
    }

    public static PeliculaDTO obtenerPorId(ObjectId id) {
        Document doc = peliculas.find(eq("_id", id)).first();
        if (doc != null) {
            return new PeliculaDTO(
                    doc.getObjectId("_id"),
                    doc.getString("usuarioId"),
                    doc.getString("titulo"),
                    doc.getString("descripcion"),
                    doc.getInteger("calificacion"),
                    doc.getBoolean("favorita"),
                    doc.getString("imagen"),
                    doc.getString("comentario"),
                    doc.getString("genero")
            );
        }
        return null;
    }

    public static List<PeliculaDTO> buscarPorTitulo(String titulo, String usuarioId) {
        List<PeliculaDTO> lista = new ArrayList<>();

        if (titulo == null || titulo.isEmpty()) {
            return lista;
        }

        // Búsqueda con regex (insensible a mayúsculas/minúsculas)
        MongoCursor<Document> cursor = peliculas.find(
                Filters.and(
                        Filters.eq("usuarioId", usuarioId),
                        Filters.regex("titulo", ".*" + titulo + ".*", "i")
                )
        ).iterator();

        while (cursor.hasNext()) {
            Document doc = cursor.next();
            lista.add(new PeliculaDTO(
                    doc.getObjectId("_id"),
                    doc.getString("usuarioId"),
                    doc.getString("titulo"),
                    doc.getString("descripcion"),
                    doc.getInteger("calificacion"),
                    doc.getBoolean("favorita"),
                    doc.getString("imagen"),
                    doc.getString("comentario"),
                    doc.getString("genero")
            ));
        }

        return lista;
    }

    public static void marcarComoFavorita(ObjectId peliculaId, String usuarioId) {
        // Encuentra la película específica del usuario y actualiza su campo 'favorita' a true
        peliculas.updateOne(
                Filters.and(
                        Filters.eq("_id", peliculaId),
                        Filters.eq("usuarioId", usuarioId)
                ),
                new Document("$set", new Document("favorita", true))
        );
    }

}
