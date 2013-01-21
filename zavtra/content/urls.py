from django.conf.urls.defaults import patterns, url

from content.views import ArticleView, RubricView, FeaturedView,\
                          ZeitungView, ArchiveView, DailyView,\
                          EventsView


urlpatterns = patterns('',
  url(r'^zeitung/$', 'content.views.current_issue_redirect', name='content.views.current_issue'),
  url(r'^zeitung/(?P<year>[0-9]+)/(?P<issue>[0-9]+)/$', ZeitungView.as_view(), name='content.views.zeitung'),
  url(r'^view/(?P<slug>[^/]+)/$', ArticleView.as_view(), name='content.views.article'),
  url(r'^rubric/(?P<slug>[^/]+)/$', RubricView.as_view(), name='content.views.rubric'),
  #url(r'^wod/$', WodView.as_view(), name='content.views.wod')
  url(r'^events/$', EventsView.as_view(), name='content.views.events_now'),
  url(r'^events/(?P<year>\d{4})/(?P<month>\d{1,2})/(?P<day>\d{1,2})/$', EventsView.as_view(), name='content.views.events'),
  url(r'^archive/$', ArchiveView.as_view(), name='content.views.archive'),
  url(r'^archive/(?P<year>\d{4})/(?P<month>\d{1,2})/(?P<day>\d{1,2})/$', ArchiveView.as_view(), name='content.views.archive_by_date'),
  url(r'^daily/(?P<year>\d{4})/(?P<month>\d{1,2})/(?P<day>\d{1,2})/$', DailyView.as_view(), name='content.views.daily'),
  url(r'^daily/$', DailyView.as_view(), name='content.views.daily_now'),
  url(r'^featured/(?P<slug>[^/]+)/$', FeaturedView.as_view(), name='content.views.topic')
)