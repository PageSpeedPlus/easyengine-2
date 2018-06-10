#!/bin/bash
# ===================================================================================
# | WordPress Auto Konfiguration
# ===================================================================================

# Ins WordPress Verzeichnis wechseln
cd /var/www/$domain
cd htdocs

# Suchmaschinen die Indexierung verbieten.
wp option update blog_public 0

# WordPress komplett updaten
wp cli update --nightly
wp core update
wp plugin update --all
wp theme update --all

# Sprache ändern
wp language core install --activate de_DE

# Datum und Zeit anpassen
wp option update date_format 'Y-m-d'
wp option update time_format 'H:i'
wp option update start_of_week 1
wp option update timezone_string 'Europe/Zurich'

# HTTPS für alle Links
wp option update home 'https://$domain'
wp option update siteurl 'https://$domain'

# Link Struktur setzten
wp rewrite structure '/%post_id%/postname' --category-base='/kat/' --tag-base='/tag/'
wp rewrite flush

# Jahr / Monat Ordner Struktur deaktivieren
wp option update uploads_use_yearmonth_folders 0

# Blog Name und Beschreibung mit vorübergehendem Inhalt füllen
wp option update blogname "PageSpeed+"
wp option update blogdescription "Professional Performance"
# wp option update admin_email someone@example.com
# wp option update default_role author

# PHP Cron Job durch Linux Systen Cron ersetzen
crontab -e
*/15 * * * * curl https://wpnginx.tk/wp-cron.php?doing_wp_cron > /dev/null 2>&1

# Kommentare per Standart deaktiviert
wp option set default_comment_status closed;

# Ping per Standart deaktiviert
wp option set default_ping_status closed;

# Standart Müll entfernen
wp plugin uninstall akismet hello
wp theme uninstall twentyfifteen twentysixteen
wp post delete $(wp post list --post_type='page' --format=ids)
wp post delete 1 --force
wp comment delete 1 --force
wp widget delete $(wp widget list sidebar-1 --format=ids);

wp plugin install --activate code-snippets worker optimus query-monitor search-by-algolia-instant-relevant-results responsify-wp snitch autodescription updraftplus vevida-optimizer ninjafirewall
# wp plugin install disqus-conditional-load elasticpress favicon-by-realfavicongenerator lazy-load-for-comments p3-profiler pods searchwp-api secsign table-of-contents-plus tablepress the-events-calendar wp-ultimate-csv-importer wp-external-links wp-sweep


# Kommentare und Pingbacks deaktivieren
wp post list --format=ids | xargs wp post update --comment_status=closed
wp post list --format=ids | xargs wp post update --ping_status=closed

# Dateiberechtigungen setzten
chown -R www-data:www-data /var/www
find /var/www/ -type d -exec chmod 755 {} \;
find /var/www/ -type f -exec chmod 644 {} \;
cd /var/www/$domain
chmod 400 wp-config.php






wp core config --extra-php <<PHP define( 'WP_POST_REVISIONS', false ); PHP
wp core config --extra-php <<PHP define( 'EMPTY_TRASH_DAYS', 2 ); PHP
wp core config --extra-php <<PHP define( 'AUTOSAVE_INTERVAL', 90 ); PHP
wp core config --extra-php <<PHP define( 'DISABLE_WP_CRON', true ); PHP
wp core config --extra-php <<PHP define( 'WPLANG', 'de_DE' ); PHP

wp core config --extra-php <<PHP define( 'UPLOADS', 'https://$domain/assets/img' ); PHP

wp core config --extra-php <<PHP define( 'FS_CHMOD_DIR', ( 0755 & ~ umask() ) ); PHP
wp core config --extra-php <<PHP define( 'FS_CHMOD_FILE', ( 0644 & ~ umask() ) ); PHP

wp core config --extra-php <<PHP define( 'WP_MEMORY_LIMIT', '256M' ); PHP
wp core config --extra-php <<PHP define( 'WP_MAX_MEMORY_LIMIT', '512M' ); PHP

wp core config --extra-php <<PHP $table_prefix = 'wp1_'; PHP

wp core config --extra-php <<PHP define( 'IMAGE_EDIT_OVERWRITE', true ); PHP

wp core config --extra-php <<PHP define( 'WP_CACHE', true ); PHP

wp core config --extra-php <<PHP define( 'WP_HTTP_BLOCK_EXTERNAL', true ); PHP
wp core config --extra-php <<PHP define( 'WP_ACCESSIBLE_HOSTS', 'api.wordpress.org,*.github.com' ); PHP

wp core config --extra-php <<PHP define( 'WP_DEBUG', true ); PHP
wp core config --extra-php <<PHP define( 'SCRIPT_DEBUG', true ); PHP
wp core config --extra-php <<PHP define( 'WP_DEBUG_LOG', false ); PHP
wp core config --extra-php <<PHP define( 'WP_DEBUG_DISPLAY', true ); PHP





