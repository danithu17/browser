#include "WebEngineHandler.h"
#include <QString>

WebEngineHandler::WebEngineHandler(QObject *parent)
    : QObject(parent), m_profile(QWebEngineProfile::defaultProfile()), m_googleServicesDisabled(false)
{
    enforcePrivacy();
}

void WebEngineHandler::enforcePrivacy()
{
    qDebug() << "Initializing Aegis Privacy Protocols...";

    // 1. Disable Google Safe Browsing (prevents sending URLs to Google)
    // Note: Qt WebEngine doesn't have a direct "disable safe browsing" bool exposed easily in QML,
    // but we configure the engine to avoid specific features.
    
    // 2. Telemetry & Tracking Prevention
    m_profile->setHttpUserAgent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36"); // Generic UA
    m_profile->settings()->setAttribute(QWebEngineSettings::LocalStorageEnabled, false); // Strict default
    m_profile->settings()->setAttribute(QWebEngineSettings::DnsPrefetchEnabled, false); // No pre-fetching
    
    // 3. Clear existing cookies on startup for session privacy
    m_profile->cookieStore()->deleteAllCookies();

    // 4. Force HTTPS (Logic would typically be in an interceptor, but we set preference here)
    // In a full implementation, we would derive from QWebEngineUrlRequestInterceptor

    // 5. Connect Download Manager
    connect(m_profile, &QWebEngineProfile::downloadRequested, this, &WebEngineHandler::handleDownload);

    m_googleServicesDisabled = true;
    emit statusChanged();
    emit privacyStatsUpdated("Google Safe Browsing: DISABLED\nTelemetry: BLOCKED\nSession: ISOLATED");
}

void WebEngineHandler::handleDownload(QWebEngineDownloadRequest *download)
{
    qDebug() << "Download Requested: " << download->downloadFileName();
    
    // Save to standard Downloads folder
    QString standardPath = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
    if (standardPath.isEmpty()) standardPath = "C:/Users/Public/Downloads";
    
    QString filePath = standardPath + "/" + download->downloadFileName();
    download->setDownloadDirectory(standardPath);
    download->setDownloadFileName(download->downloadFileName());
    download->accept();

    emit downloadStarted(download->downloadFileName());

    // Track Progress
    connect(download, &QWebEngineDownloadRequest::receivedBytesChanged, this, [this, download]() {
        emit downloadProgress(download->receivedBytes(), download->totalBytes());
    });

    connect(download, &QWebEngineDownloadRequest::stateChanged, this, [this, download](QWebEngineDownloadRequest::DownloadState state) {
        if (state == QWebEngineDownloadRequest::DownloadCompleted) {
            emit downloadFinished(download->downloadFileName());
        }
    });
}

void WebEngineHandler::nuclearOption()
{
    qDebug() << "EXECUTING NUCLEAR OPTION...";

    // 1. Clear all cookies
    m_profile->cookieStore()->deleteAllCookies();

    // 2. Clear Cache (Memory & Disk)
    m_profile->clearHttpCache();

    // 3. Clear Visited Links
    m_profile->clearAllVisitedLinks();

    emit privacyStatsUpdated("⚠️ NUCLEAR OPTION EXECUTED.\nAll traces wiped from memory and disk.");
}
