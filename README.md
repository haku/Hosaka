Hosaka - Remote Services for Onosendai
======================================

TODO Intro goes here.

API
---

Credentials via Basic Auth.

| Path                      | Verb   | Notes                                                          |
| ----                      | ----   | -----                                                          |
| `/api/user/`              | `POST` | Create new account.                                            |
| `/api/user/<uid>`         | `GET`  | Can only access own user.  User info and stats.                |
| `/api/user/<uid>/columns` | `GET`  | Fetch state of columns, filterable '?filter=h1:h2:h3'.         |
| `/api/user/<uid>/columns` | `POST` | Write state of multiple columns.  Omitted columns are ignored. |

Data Format
-----------

```json
{
  "${column_hash}": {
    "item_id": 545982340293483493,
    "item_time": 1419104543,
    "top": 25,
    "unread_time": 1419319843,
  }
}
```

| `column_hash`    | sha1 of `"#{account_type}:#{user_name}:#{column_resource}"`. |
| `account_type`   | 'twitter', 'successwhale'.                                   |
| `user_name`      | Twitter numeric account ID, SuccessWhale user name.          |
| `column_reource` | 'timeline', 'lists/foo', 'facebook/3432342/me/home'.         |
| `item_id`        | SID of top item in list.                                     |
| `item_time`      | epoch time in seconds.                                       |
| `top`            | pixel offset.                                                |
| `unread_time`    | epock time in seconds.                                       |

Resolve merge conflicts by keeping version with largest `item_time`,
i.e. furthest progress though column.

Thoughts
--------

* Sign-in via Twitter to create new accounts?  Spam prevention.
* Copy paste API key into Onosendai (at least initially).
* Start invite only? (preauth Twitter handles).

References
----------

* https://devcenter.heroku.com/articles/heroku-postgresql
* http://mherman.org/blog/2013/06/08/designing-with-class-sinatra-plus-postgresql-plus-heroku/
* http://guides.rubyonrails.org/active_record_basics.html
