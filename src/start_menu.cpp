#include <QDir>
#include <QIcon>
#include <QProcess>
#include <QSettings>
#include <QStandardPaths>
#include <QRegularExpression>
#include <QDBusMessage>
#include <QDBusConnection>
#include <KUser>

#include "start_menu.h"

Backend::Backend(QObject *parent) : QObject(parent)
{
    loadIcon();
    loadApplications();
}

void Backend::loadIcon()
{
    QStringList icon_list = {
        QStringLiteral("emblem-debian-white"),
        QStringLiteral("archlinux-logo"),
        QStringLiteral("fedora-logo")
    };

    for (const QString &icon_name : icon_list)
    {
        if (QIcon::hasThemeIcon(icon_name))
        {
            m_resolved_icon = icon_name;
            return;
        }
    }

    m_resolved_icon = QStringLiteral("start-here-kde-symbolic");
}

QString Backend::userName() const
{
    KUser user;
    QString name = user.property(KUser::FullName).toString();
    if (name.isEmpty())
        name = user.loginName();
    return name;
}

QString Backend::userProfilePicture() const
{
    KUser user;
    QString file_path = user.faceIconPath();
    if (QFile::exists(file_path))
        return file_path;

    return QStringLiteral("avatar-default");
}

void Backend::loadApplications()
{
    m_applications.clear();

    QStringList app_dirs = {
        QStandardPaths::writableLocation(QStandardPaths::ApplicationsLocation),
        QStringLiteral("/usr/local/share/applications"),
        QStringLiteral("/usr/share/applications")
    };

    QSet<QString> processed_files;

    for (const QString &dir_path : app_dirs)
    {
        QDir dir(dir_path);
        if (!dir.exists()) continue;

        QStringList filters = {QStringLiteral("*.desktop")};
        QFileInfoList file_list = dir.entryInfoList(filters, QDir::Files);

        for (const QFileInfo &file_info : file_list)
        {
            QString file_name = file_info.fileName();

            if (processed_files.contains(file_name))
                continue;

            processed_files.insert(file_name);

            QSettings desktop_file(file_info.absoluteFilePath(), QSettings::IniFormat);
            desktop_file.beginGroup(QStringLiteral("Desktop Entry"));

            bool display = !desktop_file.value(QStringLiteral("NoDisplay"), false).toBool();
            bool hidden = desktop_file.value(QStringLiteral("Hidden"), false).toBool();
            QString not_show_in = desktop_file.value(QStringLiteral("NotShowIn")).toString();
            QString type = desktop_file.value(QStringLiteral("Type")).toString();

            if (!display || hidden || not_show_in == QLatin1String("KDE") || type != QLatin1String("Application"))
            {
                desktop_file.endGroup();
                continue;
            }

            QString name = desktop_file.value(QStringLiteral("Name")).toString();
            QString icon = desktop_file.value(QStringLiteral("Icon")).toString();
            QString exec = desktop_file.value(QStringLiteral("Exec")).toString();

            exec.remove(QRegularExpression(QStringLiteral(" %[UuFfKkci]")));
            exec = exec.trimmed();

            if (!name.isEmpty())
            {
                QVariantMap app = {
                    {"name", name},
                    {"icon", (icon.isEmpty() ? QStringLiteral("application-x-executable") : icon)},
                    {"exec", exec}
                };

                m_applications.append(app);
            }

            desktop_file.endGroup();
        }
    }

    std::sort(m_applications.begin(), m_applications.end(), [](const QVariant &a, const QVariant &b) {
        return a.toMap().value("name").toString() < b.toMap().value("name").toString();
    });

    emit applicationsChanged();
}

void Backend::launchApplication(const QString &exec_command)
{
    if (!exec_command.isEmpty())
        QProcess::startDetached(exec_command);
}

void Backend::shutdownDialog()
{
    QDBusConnection::sessionBus().call(
        QDBusMessage::createMethodCall("org.kde.LogoutPrompt", "/LogoutPrompt", "org.kde.LogoutPrompt", "promptShutDown"),
        QDBus::NoBlock
    );
}

void Backend::restartDialog()
{
    QDBusConnection::sessionBus().call(
        QDBusMessage::createMethodCall("org.kde.LogoutPrompt", "/LogoutPrompt", "org.kde.LogoutPrompt", "promptReboot"),
        QDBus::NoBlock
    );
}

void Backend::logoutDialog()
{
    QDBusConnection::sessionBus().call(
        QDBusMessage::createMethodCall("org.kde.LogoutPrompt", "/LogoutPrompt", "org.kde.LogoutPrompt", "promptLogout"),
        QDBus::NoBlock
    );
}

void Backend::lockScreen()
{
    QDBusConnection::sessionBus().call(
        QDBusMessage::createMethodCall("org.freedesktop.ScreenSaver", "/ScreenSaver", "org.freedesktop.ScreenSaver", "Lock"),
        QDBus::NoBlock
    );
}
