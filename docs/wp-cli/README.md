# WP-CLI

```bash
cd /var/www/wpnginx.tk/htdocs
```

## WP Auto

```bash
bash <(wget --no-check-certificate -O - https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/bash/wp-auto)
```

### Suchmaschinen die Indexierung verbieten.

`wp option update blog_public 0`

### WordPress komplett updaten

```bash
wp cli update
wp core update
wp plugin update --all
wp theme update --all
```

### Sprache ändern

`wp language core install --activate de_DE`

### Datum und Zeit anpassen

```bash
wp option update date_format 'Y-m-d'
wp option update time_format 'H:i'
wp option update start_of_week 1
wp option update timezone_string 'Europe/Zurich'
```

### Link Struktur setzten

```bash
wp rewrite structure '/%post_id%/%postname%' --category-base='/kat/' --tag-base='/tag/'
wp rewrite flush
```

### Jahr / Monat Ordner Struktur deaktivieren

`wp option update uploads_use_yearmonth_folders 0`

### Kommentare per Standart deaktiviert

`wp option set default_comment_status closed;`

### Ping per Standart deaktiviert

`wp option set default_ping_status closed;`

### Blog Name und Beschreibung mit vorübergehendem Inhalt füllen

```bash
wp option update blogname "PageSpeed+"
wp option update blogdescription "Professional Performance"
# wp option update admin_email someone@example.com
# wp option update default_role author
```

### Standart Müll entfernen

```bash
wp plugin uninstall akismet hello
wp theme uninstall twentyfifteen twentysixteen
wp post delete $(wp post list --post_type='page' --format=ids)
wp post delete 1 --force
wp comment delete 1 --force
wp widget delete $(wp widget list sidebar-1 --format=ids);
```bash

---

## HTTPS für alle Links

```bash
wp option update home 'https://wpnginx.tk'
wp option update siteurl 'https://wpnginx.tk'
```

## Home & Blog Seite erstellen und zuweisen

```bash
wp post create --post_type=page --post_status=publish --post_title='Home'
wp post create --post_type=page --post_status=publish --post_title='Blog'
wp option update page_on_front 5
wp option update page_for_posts 10
wp option update show_on_front page
```

## PLugins installieren

```bash
wp plugin install code-snippets query-monitor snitch updraftplus vevida-optimizer ninjafirewall
p plugin install autodescription optimus search-by-algolia-instant-relevant-results responsify-wp  disqus-conditional-load elasticpress favicon-by-realfavicongenerator worker lazy-load-for-comments p3-profiler pods searchwp-api secsign table-of-contents-plus tablepress the-events-calendar wp-ultimate-csv-importer wp-external-links wp-sweep
```

## Kommentare und Pingbacks von existierenden Posts deaktivieren
wp post list --format=ids | xargs wp post update --comment_status=closed
wp post list --format=ids | xargs wp post update --ping_status=closed


## EDITOR=nano wp config edit


```bash
define( 'DISABLE_WP_CRON', true );

define( 'EMPTY_TRASH_DAYS', 2 );

define( 'UPLOADS', 'https://$domain/static/img' );

define( 'FS_CHMOD_DIR', ( 0755 & ~ umask() ) );
define( 'FS_CHMOD_FILE', ( 0644 & ~ umask() ) );

define( 'WP_MEMORY_LIMIT', '256M' );
define( 'WP_MAX_MEMORY_LIMIT', '512M' );

define( 'WP_HTTP_BLOCK_EXTERNAL', true );
define( 'WP_ACCESSIBLE_HOSTS', 'api.wordpress.org,*.github.com,updates.nintechnet.com' );

### Perfmatters Plugin bietet diese Feature im Backend

define( 'AUTOSAVE_INTERVAL', 90 );  
define( 'WP_POST_REVISIONS', false );

### Cache Enabler benütigt Zugriff auf den WP Cache um die generierten Statischten Seiten abzulegen und zu verwalten

define( 'WP_CACHE', true );

### WP Corn nicht vergessen in Linux Cron zu migrieren "crontab -e"

define( 'DISABLE_WP_CRON', true );
```

## PHP Cron Job durch Linux Systen Cron ersetzen

`sudo -s`

```bash
crontab -e
```

```bash
*/15 * * * * curl https://wpnginx.tk/wp-cron.php?doing_wp_cron > /dev/null 2>&1

* * * 1 * * bash /home/ee/skripte/ownership.sh > /dev/null 2>&1
```

## Kommandos einzelner WordPress Plugins

### ElasticPress

The following commands are supported by ElasticPress:

* `wp elasticpress index [--setup] [--network-wide] [--posts-per-page] [--nobulk] [--offset] [--show-bulk-errors] [--post-type]`

    Index all posts in the current blog.

    * `--network-wide` will force indexing on all the blogs in the network. `--network-wide` takes an optional argument to limit the number of blogs to be indexed across where 0 is no limit. For example, `--network-wide=5` would limit indexing to only 5 blogs on the network.
    * `--setup` will clear the index first and re-send the put mapping.
    * `--posts-per-page` let's you determine the amount of posts to be indexed per bulk index (or cycle).
    * `--nobulk` let's you disable bulk indexing.
    * `--offset` let's you skip the first n posts (don't forget to remove the `--setup` flag when resuming or the index will be emptied before starting again).
    * `--show-bulk-errors` displays the error message returned from Elasticsearch when a post fails to index (as opposed to just the title and ID of the post).
    * `--post-type` let's you specify which post types will be indexed (by default: all indexable post types are indexed). For example, `--post-type="my_custom_post_type"` would limit indexing to only posts from the post type "my_custom_post_type". Accepts multiple post types separated by comma.

* `wp elasticpress delete-index [--network-wide]`

  Deletes the current blog index. `--network-wide` will force every index on the network to be deleted.

* `wp elasticpress put-mapping [--network-wide]`

  Sends plugin put mapping to the current blog index. `--network-wide` will force mappings to be sent for every index in the network.

* `wp elasticpress recreate-network-alias`

  Recreates the alias index which points to every index in the network.

* `wp elasticpress activate-feature <feature-slug> [--network-wide]`

  Activate a feature. If a re-indexing is required, you will need to do it manually. `--network-wide` will affect network activated ElasticPress.

* `wp elasticpress deactivate-feature <feature-slug> [--network-wide]`

  Deactivate a feature. `--network-wide` will affect network activated ElasticPress.

* `wp elasticpress list-features [--all] [--network-wide]`

  Lists active features. `--all` will show all registered features. `--network-wide` will force checking network options as opposed to a single sites options.

* `wp elasticpress stats`

  Returns basic stats on Elasticsearch instance i.e. number of documents in current index as well as disk space used.

* `wp elasticpress status`



















