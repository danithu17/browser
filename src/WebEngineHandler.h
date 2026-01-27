#ifndef WEBENGINEHANDLER_H
#define WEBENGINEHANDLER_H

#include <QObject>
#include <QWebEngineProfile>
#include <QWebEngineSettings>
#include <QWebEngineCookieStore>
#include <QDebug>

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

signals:
    void statusChanged();
    void privacyStatsUpdated(QString message);

private:
    QWebEngineProfile *m_profile;
    bool m_googleServicesDisabled;
};

#endif // WEBENGINEHANDLER_H
