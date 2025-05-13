package DAO;

import DTO.UsuarioDTO;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import java.util.ArrayList;
import java.util.List;
import org.bson.Document;
import org.bson.types.ObjectId;

public class UsuariosDAO {

    private static MongoCollection<Document> usuarios;

    static {
        MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017");
        MongoDatabase database = mongoClient.getDatabase("biblioteca");
        usuarios = database.getCollection("usuarios");
    }

    // Método para agregar un nuevo usuario
    public static boolean agregar_usuario(UsuarioDTO usuario) {
        // Verificar si ya existe un usuario con el mismo correo
        Document correoExistente = usuarios.find(Filters.eq("correo", usuario.getCorreo())).first();
        if (correoExistente != null) {
            return false; // Correo ya registrado
        }

        // Verificar si ya existe un usuario con el mismo nombre de usuario
        Document usuarioExistente = usuarios.find(Filters.eq("usuario", usuario.getNomUsuario())).first();
        if (usuarioExistente != null) {
            return false; // Nombre de usuario ya registrado
        }

        // Si no existe, registrar
        Document doc = new Document("nomUsuario", usuario.getNomUsuario())
                .append("nombre", usuario.getNombre())
                .append("correo", usuario.getCorreo())
                .append("contrasena", usuario.getContrasena())
                .append("rol", usuario.getRol());
        usuarios.insertOne(doc);
        return true; // Registro exitoso
    }

    public static void actualizar_usuario(UsuarioDTO usuario) {
        usuarios.updateOne(
                Filters.eq("_id", usuario.getId()),
                new Document("$set", new Document("nomUsuario", usuario.getNomUsuario())
                        .append("nombre", usuario.getNombre())
                        .append("correo", usuario.getCorreo())
                        .append("contrasena", usuario.getContrasena())
                        .append("rol", usuario.getRol()))
        );
    }

    // Metodo para obtener un usuario por su ID
    public static UsuarioDTO obtener_por_id(ObjectId id) {
        Document doc = usuarios.find(Filters.eq("_id", id)).first();
        if (doc != null) {
            return new UsuarioDTO(
                    doc.getObjectId("_id"),
                    doc.getString("nomUsuario"),
                    doc.getString("nombre"),
                    doc.getString("correo"),
                    doc.getString("contrasena"),
                    doc.getString("rol")
            );
        }
        return null;
    }

    // Metodo para eliminar un usuario dado su ID
    public static void eliminar_usuario(ObjectId id) {
        usuarios.deleteOne(Filters.eq("_id", id));
    }

    // Método para obtener la lista de usuarios (solo si es administrador)
    public static List<UsuarioDTO> obtener_lista(String rol) {
        List<UsuarioDTO> listaUsuarios = new ArrayList<>();
        if ("admin".equals(rol)) {
            MongoCursor<Document> cursor = usuarios.find().iterator();
            while (cursor.hasNext()) {
                Document doc = cursor.next();
                UsuarioDTO usuario = new UsuarioDTO(
                        doc.getObjectId("_id"),
                        doc.getString("nomUsuario"),
                        doc.getString("nombre"),
                        doc.getString("correo"),
                        doc.getString("contrasena"),
                        doc.getString("rol")
                );
                listaUsuarios.add(usuario);
            }
        }
        return listaUsuarios;
    }

    // Metodo para verificar si un usuario es administrador
    public static boolean esAdmin(ObjectId id) {
        Document doc = usuarios.find(Filters.eq("_id", id)).first();
        return doc != null && "admin".equals(doc.getString("rol"));
    }

    // Metodo para verificar las credenciales de un usuario (login)
    public static UsuarioDTO verificarCredenciales(String correo, String contrasena) {
        Document doc = usuarios.find(Filters.and(
                Filters.eq("correo", correo),
                Filters.eq("contrasena", contrasena)
        )).first();

        if (doc != null) {
            return new UsuarioDTO(
                    doc.getObjectId("_id"),
                    doc.getString("nomUsuario"),
                    doc.getString("nombre"),
                    doc.getString("correo"),
                    doc.getString("contrasena"),
                    doc.getString("rol")
            );
        }
        return null;
    }

    // Metodo para buscar un usuario por correo
    public static UsuarioDTO buscarPorCorreo(String correo) {
        Document doc = usuarios.find(Filters.eq("correo", correo)).first();
        if (doc != null) {
            return new UsuarioDTO(
                    doc.getObjectId("_id"),
                    doc.getString("nomUsuario"),
                    doc.getString("nombre"),
                    doc.getString("correo"),
                    doc.getString("contrasena"),
                    doc.getString("rol")
            );
        }
        return null;
    }

    public static UsuarioDTO buscarPorNombreUsuario(String nomUsuario, String contrasena) {
        Document doc = usuarios.find(Filters.and(
                Filters.eq("nomUsuario", nomUsuario),
                Filters.eq("contrasena", contrasena) // 🔹 Validamos la contraseña correctamente
        )).first();

        if (doc != null) {
            return new UsuarioDTO(
                    doc.getObjectId("_id"),
                    doc.getString("nomUsuario"),
                    doc.getString("nombre"),
                    doc.getString("correo"),
                    doc.getString("contrasena"),
                    doc.getString("rol")
            );
        }
        return null;
    }

}
