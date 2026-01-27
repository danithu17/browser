#ifndef WEBENGINEHANDLER_H
#define WEBENGINEHANDLER_H

#include <QObject>
#include <QWebEngineProfile>
#include <QWebEngineSettings>
#include <QWebEngineCookieStore>
#include <QWebEngineDownloadRequest>
#include <QDebug>
#include <QStandardPaths>
#include <QFileDialog>

class WebEngineHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isGoogleServicesDisabled READ isGoogleServicesDisabled NOTIFY statusChanged)

public:
    explicit WebEngineHandler(QObject *parent = nullptr);

    bool isGoogleServicesDisabled() const { return m_googleServicesDisabled; }

    // The 'Nuclear Option' to wipe everything
    Q_INVOKABLE void nuclearOption();
    
    // Setup strict privacy rules
    Q_INVOKABLE void enforcePrivacy();

    // Download Management
    void handleDownload(QWebEngineDownloadRequest *download);

    // Authentication & Vault
    Q_INVOKABLE bool checkPin(QString pin);
    Q_INVOKABLE bool hasPinSet();
    Q_INVOKABLE void setPin(QString pin);
    bool isLocked() const { return m_isLocked; }

signals:
    void statusChanged();
    void privacyStatsUpdated(QString message);
    
    // Auth Signals
    void unlocked();
    void loginFailed();

    // Download Signals
    void downloadStarted(QString name);
    void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void downloadFinished(QString name);

private:
    QWebEngineProfile *m_profile;
    bool m_googleServicesDisabled;
    bool m_isLocked;
    QString m_storedPinHash; // In real app, store in QSettings or Keychain
};

#endif // WEBENGINEHANDLER_H
