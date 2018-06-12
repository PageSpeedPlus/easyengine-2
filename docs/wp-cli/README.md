# Home & Blog Seite erstellen und zuweisen

wp post create --post_type=page --post_status=publish --post_title='Home'
wp post create --post_type=page --post_status=publish --post_title='Blog'
wp post list --post_type=page

echo "Setze die ID von Home oder Blog welche du oben siehst anstatt der letzten Zahl in den Beispielen unten. Das 3. Beispiel genau so übernehmen."
echo ""
echo "wp option update page_on_front 5"
echo "wp option update page_for_posts 10"
echo "wp option update show_on_front page"
echo ""


# wp plugin install disqus-conditional-load elasticpress search-by-algolia-instant-relevant-results responsify-wp favicon-by-realfavicongenerator worker lazy-load-for-comments p3-profiler pods searchwp-api secsign table-of-contents-plus tablepress the-events-calendar wp-ultimate-csv-importer wp-external-links wp-sweep

# Kommentare und Pingbacks deaktivieren
# wp post list --format=ids | xargs wp post update --comment_status=closed
# wp post list --format=ids | xargs wp post update --ping_status=closed



echo "EDITOR=nano wp config edit"




define( 'EMPTY_TRASH_DAYS', 2 );

define( 'UPLOADS', 'https://$domain/static/img' );

define( 'FS_CHMOD_DIR', ( 0755 & ~ umask() ) );
define( 'FS_CHMOD_FILE', ( 0644 & ~ umask() ) );

define( 'WP_MEMORY_LIMIT', '256M' );
define( 'WP_MAX_MEMORY_LIMIT', '512M' );

# Perfmatters Plugin bietet diese Feature im Backend

define( 'AUTOSAVE_INTERVAL', 90 );  
define( 'WP_POST_REVISIONS', false );

# Cache Enabler benütigt Zugriff auf den WP Cache um die generierten Statischten Seiten abzulegen und zu verwalten

define( 'WP_CACHE', true );

# WP Corn nicht vergessen in Linux Cron zu migrieren "crontab -e"

define( 'DISABLE_WP_CRON', true );

sudo -s


# Als root user

# PHP Cron Job durch Linux Systen Cron ersetzen

crontab -e

*/15 * * * * curl https://wpnginx.tk/wp-cron.php?doing_wp_cron > /dev/null 2>&1

* * * 1 * * bash /home/ee/skripte/ownership.sh > /dev/null 2>&1

