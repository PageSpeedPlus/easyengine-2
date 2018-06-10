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




wp rewrite structure --category_base '/kat/' --tag-base '/tag/' '/%post_id%/postname'

