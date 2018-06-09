
#!/bin/bash
# ===================================================================================
# | WordPress Auto Konfiguration
# ===================================================================================
wp cli update
wp core update
wp db update
wp plugin update --all
wp theme update --all
wp plugin uninstall akismet hello-dolly
wp theme uninstall twentyfifteen twentysixteen


wp core config --extra-php <<PHP define( 'WP_DEBUG', true ); PHP

wp rewrite structure --category_base '/kat/' --tag-base '/tag/' '/%post_id%/%postname%'
