#!/bin/bash
# ===================================================================================
# | WordPress Auto Konfiguration
# ===================================================================================

# echo ""
# echo "Domain eingeben!"
# echo ""
# read -r domain

# Ins WordPress Verzeichnis wechseln
cd /var/www/wpnginx.tk
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
wp option update home 'https://wpnginx.tk'
wp option update siteurl 'https://wpnginx.tk'

# Link Struktur setzten
wp rewrite structure '/%post_id%/%postname%' --category-base='/kat/' --tag-base='/tag/'
wp rewrite flush

# Jahr / Monat Ordner Struktur deaktivieren
wp option update uploads_use_yearmonth_folders 0

# Blog Name und Beschreibung mit vorübergehendem Inhalt füllen
wp option update blogname "PageSpeed+"
wp option update blogdescription "Professional Performance"
# wp option update admin_email someone@example.com
# wp option update default_role author

# Kommentare per Standart deaktiviert
wp option set default_comment_status closed;

# Ping per Standart deaktiviert
wp option set default_ping_status closed;

# wp post create --post_type=page --post_status=publish --post_title='Home'
# wp option update page_on_front 5
# wp option update page_for_posts 10
# wp option update show_on_front page

# Standart Müll entfernen
wp plugin uninstall akismet hello
wp theme uninstall twentyfifteen twentysixteen
wp post delete $(wp post list --post_type='page' --format=ids)
wp post delete 1 --force
wp comment delete 1 --force
wp widget delete $(wp widget list sidebar-1 --format=ids);

wp plugin install code-snippets optimus query-monitor search-by-algolia-instant-relevant-results responsify-wp snitch autodescription updraftplus vevida-optimizer ninjafirewall
# wp plugin install disqus-conditional-load elasticpress favicon-by-realfavicongenerator worker lazy-load-for-comments p3-profiler pods searchwp-api secsign table-of-contents-plus tablepress the-events-calendar wp-ultimate-csv-importer wp-external-links wp-sweep

# Kommentare und Pingbacks deaktivieren
# wp post list --format=ids | xargs wp post update --comment_status=closed
# wp post list --format=ids | xargs wp post update --ping_status=closed



# Induviduell

EDITOR=nano wp config edit

define( 'DISABLE_WP_CRON', true );

define( 'EMPTY_TRASH_DAYS', 2 );

define( 'UPLOADS', 'https://$domain/static/img' );

define( 'FS_CHMOD_DIR', ( 0755 & ~ umask() ) );
define( 'FS_CHMOD_FILE', ( 0644 & ~ umask() ) );

define( 'WP_MEMORY_LIMIT', '256M' );
define( 'WP_MAX_MEMORY_LIMIT', '512M' );

define( 'WP_HTTP_BLOCK_EXTERNAL', true );
define( 'WP_ACCESSIBLE_HOSTS', 'api.wordpress.org,*.github.com,updates.nintechnet.com' );

# Perfmatters Plugin bietet diese Feature im Backend

define( 'AUTOSAVE_INTERVAL', 90 );  
define( 'WP_POST_REVISIONS', false );

# Cache Enabler benütigt Zugriff auf den WP Cache um die generierten Statischten Seiten abzulegen und zu verwalten

define( 'WP_CACHE', true );

# WP Corn nicht vergessen in Linux Cron zu migrieren "crontab -e"

define( 'DISABLE_WP_CRON', true );




# Als root user

# PHP Cron Job durch Linux Systen Cron ersetzen
crontab -e
echo "*/15 * * * * curl https://wpnginx.tk/wp-cron.php?doing_wp_cron > /dev/null 2>&1"

# Dateiberechtigungen setzten
# chown -R www-data:www-data /var/www
# find /var/www/ -type d -exec chmod 755 {} \;
# find /var/www/ -type f -exec chmod 644 {} \;
# cd /var/www/wpnginx.tk
# chmod 400 wp-config.php








#wp core config --extra-php <<PHP define( 'WP_DEBUG', true ); PHP
#wp core config --extra-php <<PHP define( 'SCRIPT_DEBUG', true ); PHP
#wp core config --extra-php <<PHP define( 'WP_DEBUG_LOG', false ); PHP
#wp core config --extra-php <<PHP define( 'WP_DEBUG_DISPLAY', true ); PHP





