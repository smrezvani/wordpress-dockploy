<?php
/**
 * Domain Validator - Must-Use Plugin
 * Ensures WordPress only responds to its configured domain
 * Prevents cross-site content serving when reverse proxy misroutes
 */

// Get allowed domain from environment or WordPress settings
$allowed_host = getenv('WORDPRESS_SITE_HOST') ?: parse_url(get_option('siteurl'), PHP_URL_HOST);

// Get current request host
$request_host = $_SERVER['HTTP_HOST'] ?? '';

// Remove port if present
$request_host = explode(':', $request_host)[0];
$allowed_host = explode(':', $allowed_host)[0];

// Allow www prefix
$allowed_hosts = [
    $allowed_host,
    'www.' . $allowed_host,
    'localhost', // For health checks
    'nginx'      // For internal loopback
];

// Validate domain
if (!in_array($request_host, $allowed_hosts)) {
    // Log the invalid request for debugging
    error_log("Domain validation failed: Requested host '$request_host' not in allowed hosts: " . implode(', ', $allowed_hosts));
    
    // Return 444 to close connection (same as nginx)
    http_response_code(444);
    exit;
}

// Additionally, force WordPress to use the correct domain
if (!defined('WP_SITEURL') && $allowed_host && !in_array($request_host, ['localhost', 'nginx'])) {
    $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
    define('WP_SITEURL', $protocol . '://' . $allowed_host);
    define('WP_HOME', $protocol . '://' . $allowed_host);
}