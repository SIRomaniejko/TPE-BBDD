{include file="header.tpl"}
<div class="container mt-3">
    <form action="posicionesLibres" method="post">
        <div class="form-group">
            <label for="fecha">Fecha</label>
            <input type="date" class="form-control" name="fecha" id="fecha" placeholder="apellido">
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-secondary btn-block">Enviar</button>
        </div>
    </form>
</div>
<div class="container">
    <form action="posicionesOcupadasCliente" method="post">
        <div class="form-group">
            <label for="cuit">Cuit/Cuil</label>
            <input type="number" class="form-control" name="cuit" id="cuit" placeholder="12123123">
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-secondary btn-block">Enviar</button>
        </div>
    </form>
</div>
<script src="js/jquery-3.0.0.min.js" charset="utf-8"></script> <!-- Llamado a la biblioteca javascript de bootstrap-->
{include file="footer.tpl"}