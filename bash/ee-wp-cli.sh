#!/bin/bash
# ===================================================================================
# | WordPress Auto Konfiguration
# ===================================================================================

# Ins WordPress Verzeichnis wechseln
cd /var/www/$domain
cd htdocs

# WordPress komplett updaten
wp cli update
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


# Standart Müll entfernen
wp plugin uninstall akismet hello-dolly
wp theme uninstall twentyfifteen twentysixteen


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





