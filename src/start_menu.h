#ifndef START_MENU_H
#define START_MENU_H

#include <QObject>
#include <QString>
#include <QVariantList>
#include <QtQml>

class Backend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString userName READ userName CONSTANT)
    Q_PROPERTY(QString userProfilePicture READ userProfilePicture CONSTANT)
    Q_PROPERTY(QString resolvedIcon READ resolvedIcon NOTIFY resolvedIconChanged)
    Q_PROPERTY(QVariantList applicationList READ applicationList NOTIFY applicationsChanged)
    QML_ELEMENT

public:
    explicit Backend(QObject *parent = nullptr);

    QString resolvedIcon() const;
    QString userName() const;
    QString userProfilePicture() const;
    QVariantList applicationList() const;

    Q_INVOKABLE void launchApplication(const QString &exec);

    Q_INVOKABLE void shutdownDialog();
    Q_INVOKABLE void restartDialog();
    Q_INVOKABLE void logoutDialog();
    Q_INVOKABLE void lockScreen();

signals:
    void hideRequested();
    void resolvedIconChanged();
    void applicationsChanged();

private:
    QFileSystemWatcher m_watcher;

    inline static const QStringList k_app_dirs = {
        QStandardPaths::writableLocation(QStandardPaths::ApplicationsLocation),
        QStringLiteral("/usr/local/share/applications"),
        QStringLiteral("/usr/share/applications")
    };
};

#endif /* START_MENU_H */
