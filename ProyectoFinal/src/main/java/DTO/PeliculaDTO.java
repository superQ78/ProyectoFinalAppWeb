package DTO;

import org.bson.types.ObjectId;

/**
 *
 * @author equipo
 */
public class PeliculaDTO {

    private ObjectId id;
    private String usuarioId;
    private String titulo;
    private String descripcion;
    private int calificacion; // de 1 a 5
    private boolean favorita;
    private String imagen; // ruta a la imagen
    private String comentario;
    private String genero;

    public PeliculaDTO() {
    }

    public PeliculaDTO(ObjectId id, String usuarioId, String titulo, String descripcion, int calificacion, boolean favorita, String imagen, String comentario, String genero) {
        this.id = id;
        this.usuarioId = usuarioId;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.calificacion = calificacion;
        this.favorita = favorita;
        this.imagen = imagen;
        this.comentario = comentario;
        this.genero = genero;
    }

    public ObjectId getId() {
        return id;
    }

    public void setId(ObjectId id) {
        this.id = id;
    }

    public String getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(String usuarioId) {
        this.usuarioId = usuarioId;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public int getCalificacion() {
        return calificacion;
    }

    public void setCalificacion(int calificacion) {
        this.calificacion = calificacion;
    }

    public boolean isFavorita() {
        return favorita;
    }

    public void setFavorita(boolean favorita) {
        this.favorita = favorita;
    }

    public String getImagen() {
        return imagen;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }

    public String getComentario() {
        return comentario;
    }

    public void setComentario(String comentario) {
        this.comentario = comentario;
    }

    public String getGenero() {
        return genero;
    }

    public void setGenero(String genero) {
        this.genero = genero;
    }

}
