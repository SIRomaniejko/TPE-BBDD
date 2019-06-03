<link rel="stylesheet" href="css/leaflet.css"> <!-- Llamado a la biblioteca de estilos de la api Leaflet (Aplicacion de mapas Free)-->
<form action="posicionesLibres" method="post">
    <div class="form-group">
          <label for="fecha">Fecha</label>
          <input type="date" class="form-control" name="fecha" id="fecha" placeholder="apellido">
        </div>
    <div class="form-group">
    <button type="submit" class="btn btn-primary">Enviar</button>
</form>
<form action="posicionesOcupadasCliente" method="post">
    <div class="form-group">
        <label for="cuit">Cuit/Cuil</label>
        <input type="number" class="form-control" name="cuit" id="cuit" placeholder="12123123">
    </div>
    <div class="form-group">
    <button type="submit" class="btn btn-primary">Enviar</button>
</form>
<script src="js/jquery-3.0.0.min.js" charset="utf-8"></script> <!-- Llamado a la biblioteca javascript de bootstrap-->