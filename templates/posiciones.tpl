{include file="header.tpl"}
<div class="container">
	<div class="alert alert-secondary mt-3" role="alert">
		{$titulo}
	</div>
	<table class="table">
	<thead>
		<tr>
		<th scope="col">Nro Posicion</th>
		<th scope="col">Nro Estantería</th>
		<th scope="col">Nro Fila</th>
		</tr>
	</thead>
	<tbody>
		{foreach from=$posiciones item=posicion}
			<tr>
				<td>{$posicion['nro_posicion']}</td>
				<td>{$posicion['nro_estanteria']}</td>
				<td>{$posicion['nro_fila']}</td>
			</tr>
		{/foreach}
	</tbody>
	</table>
</div>
{include file="footer.tpl"}