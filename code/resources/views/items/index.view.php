<?php
    use App\Library\View;
    use App\Library\Auth;
?>

<?php foreach($viewParams['items'] as $item): ?>
    <div style="padding-bottom: 5em;">
        <h2>
            <a href="/shop/<?php echo View::escape($item['id']); ?>">
                <?php echo View::escape($item['name']); ?>
            </a>
        </h2>
        <hr/>
        <div class="row" style="padding-bottom: 1em">
            <div class="col-md-6">
                <p><?php echo View::escape($item['description']); ?></p>
            </div>
            <div class="col-md-6">
                <img class="img-responsive" src="<?php echo View::escape($item['image']); ?>">
            </div>
        </div>
        <div>
            <ul class="list-inline">
                <?php if(Auth::check()): ?>
                    <li><a class="btn btn-success" href="/cart/add/<?php echo View::escape($item['id']); ?>">Add to cart</a></li>
                <?php else: ?>
                    <li>
                        <button type="button" class="btn btn-default" data-toggle="tooltip" data-placement="right" title="Please login before add to cart">Add to cart</button>
                    </li>
                <?php endif ?>
            </ul>
        </div>
    </div>
<?php endforeach ?>
<script>
$(function () {
    $('[data-toggle="tooltip"]').tooltip()
})
</script>
